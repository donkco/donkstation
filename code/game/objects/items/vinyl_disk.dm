/**
 * Vinyl record item.
 *
 * Stores up to two tracks (A side and B side).
 * Activate in-hand to flip between sides when a B-side track is present.
 */
/obj/item/vinyl_disk
	name = "vinyl record"
	desc = "A vinyl record. It smells faintly of nostalgia."
	icon = 'icons/obj/machines/vinylplayer.dmi'
	icon_state = "record_vinyl_out"
	w_class = WEIGHT_CLASS_TINY

	/// Type path of the A-side track datum.
	var/track_a_type = /datum/track/default
	/// Type path of the B-side track datum. Null means no B-side.
	var/track_b_type = null

	/// Instantiated A-side track.
	var/datum/track/track_a
	/// Instantiated B-side track.
	var/datum/track/track_b

	/// Whether we are currently presenting the B-side.
	var/playing_b_side = FALSE

	/// Icon state shown when the A side is active. Falls back to icon_state if null.
	var/a_side_icon_state = "record_vinyl_out"
	/// Icon state shown when the B side is active. Falls back to a_side_icon_state then icon_state if null.
	var/b_side_icon_state = "record_cd_out"
	/// Icon state used as an overlay on the vinyl player when A side is loaded.
	var/playing_state = "record"
	/// Icon state used as an overlay on the vinyl player when B side is loaded. Falls back to playing_state if null.
	var/b_side_playing_state = "record_cd"

/obj/item/vinyl_disk/Initialize(mapload)
	. = ..()
	if(track_a_type)
		track_a = new track_a_type()
	if(track_b_type)
		track_b = new track_b_type()

/obj/item/vinyl_disk/Destroy()
	QDEL_NULL(track_a)
	QDEL_NULL(track_b)
	return ..()

/obj/item/vinyl_disk/examine(mob/user)
	. = ..()
	var/datum/track/current = get_current_track()
	if(current)
		. += "The label reads: [span_notice(current.song_name)]."
	if(track_b)
		. += "It has content on both sides. Activate it in-hand to flip it over."

/// Returns the currently active track datum.
/obj/item/vinyl_disk/proc/get_current_track()
	if(playing_b_side && track_b)
		return track_b
	return track_a

/obj/item/vinyl_disk/update_icon_state()
	if(playing_b_side)
		icon_state = b_side_icon_state || a_side_icon_state || icon_state
	else
		icon_state = a_side_icon_state || icon_state
	return ..()

/obj/item/vinyl_disk/attack_self(mob/user)
	if(!track_b)
		balloon_alert(user, "only one side")
		return
	playing_b_side = !playing_b_side
	update_appearance(UPDATE_ICON_STATE)
	var/datum/track/current = get_current_track()
	balloon_alert(user, "flipped to [playing_b_side ? "B" : "A"] side: [current.song_name]")

// Default disk with the default jukebox track
/obj/item/vinyl_disk/default
	name = "vinyl record - \"Tintin on the Moon\" & \"Title Theme 2\""
	track_a_type = /datum/track/default
	track_b_type = /datum/track/title2

/**
 * A disk pre-loaded with a track from the jukebox config file.
 *
 * Set `config_track_name` to the exact track name from the config,
 */
/obj/item/vinyl_disk/config_track
	name = "vinyl record"
	track_a_type = null
	/// Name of the top track on the top side the disk
	var/config_track_a_name = null
	/// Name of the track on the flip-side of the disk
	var/config_track_b_name = null

/obj/item/vinyl_disk/config_track/Initialize(mapload)
	// We handle track init ourselves; skip the type-based init in the parent.
	. = ..()
	var/list/config_songs = get_jukebox_config_songs()
	var/datum/track/found_a
	if(config_track_a_name)
		found_a = config_songs[config_track_a_name]
	if(found_a)
		track_a = found_a
	else
		stack_trace("[type] could not find config track '[config_track_a_name || "(random)"]'")
		track_a = new /datum/track/default()
	if(config_track_b_name)
		var/datum/track/found_b = config_songs[config_track_b_name]
		if(found_b)
			track_b = found_b
		else
			stack_trace("[type] could not find config B-side track '[config_track_b_name]'")
	if(track_a && track_b)
		name = "vinyl disk - \"[track_a.song_name]\" & \"[track_b.song_name]\""
	else if(track_a)
		name = "vinyl disk - \"[track_a.song_name]\""

///Sleeve that you can put your disks in!
/obj/item/vinyl_sleeve
	name = "vinyl sleeve"
	desc = "A protective paper sleeve for a vinyl record."
	icon = 'icons/obj/machines/vinylplayer.dmi'
	icon_state = "sleeve_donk"
	w_class = WEIGHT_CLASS_SMALL

	/// The disk currently stored in this sleeve, if any.
	var/obj/item/vinyl_disk/stored_disk = null

/obj/item/vinyl_sleeve/Destroy()
	QDEL_NULL(stored_disk)
	return ..()

/obj/item/vinyl_sleeve/examine(mob/user)
	. = ..()
	if(stored_disk)
		var/datum/track/current = stored_disk.get_current_track()
		. += "Inside is [stored_disk.name][current ? " — [current.song_name]" : null]."
	else
		. += "It is empty."

/obj/item/vinyl_sleeve/update_icon_state()
	icon_state = stored_disk ? "sleeve_donk" : "sleeve_donk"
	return ..()

/obj/item/vinyl_sleeve/attack_self(mob/user)
	if(!stored_disk)
		balloon_alert(user, "there is no disk inside!")
		return
	var/obj/item/vinyl_disk/disk = stored_disk
	stored_disk = null
	update_appearance(UPDATE_ICON_STATE)
	user.put_in_hands(disk)
	balloon_alert(user, "you remove [disk.name] from the sleeve")

/obj/item/vinyl_sleeve/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/vinyl_disk))
		return NONE
	if(stored_disk)
		balloon_alert(user, "there already is a disk inside!")
		return ITEM_INTERACT_BLOCKING
	var/obj/item/vinyl_disk/disk = tool
	user.transferItemToLoc(disk, src)
	stored_disk = disk
	update_appearance(UPDATE_ICON_STATE)
	balloon_alert(user, "you insert [disk.name] into the sleeve")
	return ITEM_INTERACT_SUCCESS
