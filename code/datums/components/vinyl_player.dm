///Vinyl player version of jukebox behavior. Allows for loading vinyl records and supports setting tracks directly.
/datum/jukebox/vinyl_player
	sound_range = 5
	sound_loops = FALSE
	requires_range_check = TRUE

/datum/jukebox/vinyl_player/New(atom/new_parent)
	sound_channel = SSsounds.reserve_sound_channel(src)
	..()

/datum/jukebox/vinyl_player/init_songs()
	return list() // Track is set externally via set_track()

/// Swaps the playing track without recreating the datum.
/// Stops any current playback before switching.
/datum/jukebox/vinyl_player/proc/set_track(datum/track/new_track)
	unlisten_all()
	songs.Cut()
	if(new_track)
		songs[new_track.song_name] = new_track
		selection = new_track
	else
		selection = null

//-----------------------------------------------------------------------
// Vinyl Player Component
//-----------------------------------------------------------------------

///Component that handles something being able to play vinyl records which lets us play similarly to the jukebox except with records that can be inserted/removed
/datum/component/vinyl_player
	/// Currently loaded vinyl record.
	var/obj/item/vinyl_disk/loaded_record = null
	/// The jukebox datum driving playback.
	var/datum/jukebox/vinyl_player/music_player = null
	/// Whether we are actively playing.
	var/playing = FALSE
	/// Position of song; saved when paused
	var/playback_offset = 0
	/// Timer ID for detecting when the current song ends.
	var/song_timerid
	/// If TRUE, uses item-mode signals (activate-in-hand) instead of click signals.
	var/item_mode = FALSE
	/// Base icon_state of the parent, cached at init for update_icon_state handling.
	var/base_icon_state

/datum/component/vinyl_player/Initialize()
	. = ..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	item_mode = isitem(parent)
	base_icon_state = parent.vars["base_icon_state"]
	music_player = new /datum/jukebox/vinyl_player(parent)

/datum/component/vinyl_player/Destroy()
	stop_playback()
	QDEL_NULL(music_player)
	return ..()

/datum/component/vinyl_player/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_item_interaction))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_parent_deleting))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM, PROC_REF(on_context))
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_ICON_STATE, PROC_REF(on_update_icon_state))

	var/atom/parent_atom = parent
	parent_atom.flags_1 |= HAS_CONTEXTUAL_SCREENTIPS_1

	if(item_mode)
		RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_play_pause))
		RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF_SECONDARY, PROC_REF(on_eject))
	else
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_play_pause))
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND_SECONDARY, PROC_REF(on_eject))
		RegisterSignal(parent, COMSIG_ATOM_TOOL_ACT(TOOL_WRENCH), PROC_REF(on_wrench_act))

/datum/component/vinyl_player/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_ATOM_ITEM_INTERACTION,
		COMSIG_QDELETING,
		COMSIG_ATOM_EXAMINE,
		COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM,
		COMSIG_ATOM_UPDATE_ICON_STATE,
		COMSIG_ITEM_ATTACK_SELF,
		COMSIG_ITEM_ATTACK_SELF_SECONDARY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_ATTACK_HAND_SECONDARY,
	))
	return ..()

/// Blocks wrenching while the record player is actively playing.
/datum/component/vinyl_player/proc/on_wrench_act(atom/source, mob/living/user, obj/item/tool)
	SIGNAL_HANDLER
	if(!playing)
		return ITEM_INTERACT_SUCCESS
	source.balloon_alert(user, "turning it off first might be safer.")
	return ITEM_INTERACT_BLOCKING

/// When the parent is deleted, drop any loaded record to the turf so it isn't lost.
/datum/component/vinyl_player/proc/on_parent_deleting(atom/source)
	SIGNAL_HANDLER
	if(!loaded_record)
		return
	stop_playback()
	loaded_record.forceMove(get_turf(source))
	loaded_record = null

/// Handles contextual screentip context for both item and machinery parents.
/datum/component/vinyl_player/proc/on_context(atom/source, list/context, obj/item/held_item, mob/user)
	SIGNAL_HANDLER
	if(loaded_record)
		context[SCREENTIP_CONTEXT_LMB] = playing ? "Pause" : "Play"
		context[SCREENTIP_CONTEXT_RMB] = "Take out record"
	else
		context[SCREENTIP_CONTEXT_LMB] = "Insert record"
	return CONTEXTUAL_SCREENTIP_SET

/// Appends record status lines when the parent is examined.
/datum/component/vinyl_player/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(loaded_record)
		var/datum/track/current = loaded_record.get_current_track()
		if(current)
			examine_list += "The record reads: [span_notice(current.song_name)]."
		if(playing)
			examine_list += "It's currently playing."
	else
		examine_list += item_mode ? "There is no record inside." : "The turntable is empty. Insert a vinyl record to jam."

/// Updates the parent's icon_state to reflect playback status.
/datum/component/vinyl_player/proc/on_update_icon_state(atom/source)
	SIGNAL_HANDLER
	source.icon_state = "[base_icon_state][playing ? "-active" : null]"

/// Called when an item is used on the parent. Handles record insertion.
/datum/component/vinyl_player/proc/on_item_interaction(atom/source, mob/living/user, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER
	if(!istype(tool, /obj/item/vinyl_disk))
		return
	if(loaded_record)
		var/atom/parent_atom = parent
		parent_atom.balloon_alert(user, "there already is a record inside!")
		return ITEM_INTERACT_BLOCKING
	load_record(tool, user)
	return ITEM_INTERACT_SUCCESS

/// Called on LMB (machine) or activate-in-hand (item). Toggles play/pause.
/datum/component/vinyl_player/proc/on_play_pause(atom/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(toggle_playback), user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/// Called on RMB (machine) or secondary activate-in-hand (item). Ejects the record.
/datum/component/vinyl_player/proc/on_eject(atom/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(eject_record), user)
	return COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN

/// Loads a record into the player and updates the jukebox track.
/datum/component/vinyl_player/proc/load_record(obj/item/vinyl_disk/record, mob/user)
	loaded_record = record
	record.forceMove(parent)
	music_player.set_track(record.get_current_track())
	var/atom/parent_atom = parent
	parent_atom.update_appearance(UPDATE_ICON_STATE)
	parent_atom.balloon_alert(user, "record loaded")

/// Ejects the record, stopping playback and returning it to the user's hands.
/datum/component/vinyl_player/proc/eject_record(mob/user)
	if(!loaded_record)
		var/atom/parent_atom = parent
		parent_atom.balloon_alert(user, "there is no record inside!")
		return
	stop_playback()
	music_player.set_track(null)
	var/obj/item/vinyl_disk/record = loaded_record
	loaded_record = null
	user.put_in_hands(record)
	var/atom/parent_atom = parent
	parent_atom.update_appearance(UPDATE_ICON_STATE)
	parent_atom.balloon_alert(user, "record ejected")

/// Toggles between playing and paused states.
/datum/component/vinyl_player/proc/toggle_playback(mob/user)
	if(!loaded_record)
		var/atom/parent_atom = parent
		parent_atom.balloon_alert(user, "there is no record inside!")
		return
	if(playing)
		pause_playback(user)
	else
		start_playback(user)

/// Starts (or resumes) playback from the current offset.
/datum/component/vinyl_player/proc/start_playback(mob/user)
	if(!isnull(music_player.active_song_sound))
		// Sound is still alive from a pause — resume in place.
		music_player.resume_music()
	else
		music_player.start_music()
	playing = TRUE
	var/remaining = music_player.selection.song_length - playback_offset
	if(remaining > 0)
		song_timerid = addtimer(CALLBACK(src, PROC_REF(song_ended)), remaining, TIMER_UNIQUE | TIMER_STOPPABLE | TIMER_DELETE_ME)
	var/atom/parent_atom = parent
	parent_atom.update_appearance(UPDATE_ICON_STATE)
	if(user)
		parent_atom.balloon_alert(user, "you start the player")

/// Pauses playback using SOUND_PAUSED; queries clients for the real playback position.
/datum/component/vinyl_player/proc/pause_playback(mob/user)
	deltimer(song_timerid)
	playback_offset = music_player.query_playback_offset()
	music_player.pause_music()
	playing = FALSE
	var/atom/parent_atom = parent
	parent_atom.update_appearance(UPDATE_ICON_STATE)
	if(user)
		parent_atom.balloon_alert(user, "you stop the player")

/// Stops playback and resets the offset to zero.
/datum/component/vinyl_player/proc/stop_playback()
	if(!playing)
		return
	deltimer(song_timerid)
	if(music_player)
		music_player.unlisten_all()
	playback_offset = 0
	playing = FALSE

/// Called by timer when the track finishes naturally.
/datum/component/vinyl_player/proc/song_ended()
	if(music_player)
		music_player.unlisten_all()
	playback_offset = 0
	playing = FALSE
	var/atom/parent_atom = parent
	parent_atom.update_appearance(UPDATE_ICON_STATE)
