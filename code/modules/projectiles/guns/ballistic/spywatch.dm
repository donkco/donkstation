/obj/item/spywatch
	name = "Wristwatch"
	desc = "A luxury wristwatch, packed with all the latest quartz timekeeping and LCD technology."
	slot_flags = ITEM_SLOT_L_TRINKET | ITEM_SLOT_R_TRINKET
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "watch"
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/cooldown/mob_cooldown/fire_spywatch)

	///Holds a reference to the gun this watch can fire
	var/obj/item/gun/ballistic/my_gun
	///Whether or not the breech is open (Allowing you to load the weapon)
	var/breech_open = FALSE


/obj/item/spywatch/Initialize(mapload)
	. = ..()
	my_gun = new /obj/item/gun/ballistic/spywatch(src)

/obj/item/spywatch/examine(mob/user)
	. = ..()
	. += span_info("Station Time: [server_timestamp(ic_time = TRUE, twelve_hour_clock = user.client?.prefs.read_preference(/datum/preference/toggle/twelve_hour))]")

/obj/item/spywatch/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	return try_fire(interacting_with, user, modifiers)

/obj/item/spywatch/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return try_fire(interacting_with, user, modifiers)

/obj/item/spywatch/attack_hand(mob/user, list/modifiers)
	if(loc != user || !user.is_holding(src))
		return ..()
	toggle_breech(user)

/obj/item/spywatch/attack_self(mob/user, modifiers)
	. = ..()
	toggle_breech(user)

///Inserting the round is handled through this function
/obj/item/spywatch/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(breech_open)
		my_gun.item_interaction(user, tool, modifiers)
		update_appearance(UPDATE_ICON_STATE)

/obj/item/spywatch/update_icon_state()
	. = ..()
	if(breech_open)
		if(my_gun.chambered)
			icon_state = "watch_loaded"
		else
			icon_state = "watch_open"
	else
		icon_state = "watch"

/obj/item/spywatch/Destroy(force)
	. = ..()
	if(my_gun)
		my_gun.Destroy()

/obj/item/spywatch/proc/toggle_breech(mob/user)
	breech_open = !breech_open
	if(breech_open)
		balloon_alert(user, "You open the hidden compartment.")
		my_gun.unload_ammo(user, TRUE)
		my_gun.process_chamber(TRUE, FALSE, FALSE)
	else
		balloon_alert(user, "You close the hidden compartment.")
	update_appearance(UPDATE_ICON_STATE)
	return

/obj/item/spywatch/proc/try_fire(atom/interacting_with, mob/living/user, list/modifiers)
	if(breech_open)
		balloon_alert(user, "You can't do this while the hidden compartment is open!")
		return FALSE
	var/fired = my_gun.try_fire_gun(interacting_with, user, list2params(modifiers))
	return fired




///The gun we put into the spywatch, so we can use it to actually fire the weapon
/obj/item/gun/ballistic/spywatch
	dry_fire_sound = 'sound/items/weapons/gun/pistol/dry_fire.ogg'
	suppressed_sound = 'sound/items/weapons/gun/general/tiny_suppressed_shot.ogg'
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/spywatch
	spawnwithmagazine = TRUE
	tac_reloads = FALSE
	bolt_type = BOLT_TYPE_NO_BOLT
	suppressed = SUPPRESSED_VERY
	pinless = TRUE
	internal_magazine = TRUE

/obj/item/ammo_box/magazine/internal/spywatch
	name = "spywatch internal magazine"
	desc = "Oh god, this shouldn't be here"
	ammo_type = /obj/item/ammo_casing/spywatch
	caliber = CALIBER_2MM
	max_ammo = 1

///Casing thats put inside of the spywatch
/obj/item/ammo_casing/spywatch
	name = "'Scylla's Kiss' 2mm mollusk toxin round"
	desc = "A 2mm bullet casing, it has a faint smell of the sea..."

	icon = 'icons/obj/weapons/guns/donk_ammo.dmi'
	icon_state = "2mm_casing"

	caliber = CALIBER_2MM
	projectile_type = /obj/projectile/bullet/spywatch


///Projectile fired by the spywatch, coated in a toxin that blinds and slurs speech, making it ideal for non-lethal takedowns of organic targets.
/obj/projectile/bullet/spywatch
	name = "'Scylla's Kiss' 2mm mollusk toxin bullet"
	damage = 15
	var/blindness_duration = 10 SECONDS
	var/slurring_duration = 30 SECONDS

/obj/projectile/bullet/spywatch/on_hit(atom/target, blocked = 0, pierce_hit)
	..()
	if(!iscarbon(target))
		return BULLET_ACT_HIT
	var/mob/living/hit_living = target
	if(hit_living.mob_biotypes & MOB_ORGANIC)
		hit_living.adjust_temp_blindness(blindness_duration)
		hit_living.adjust_slurring(slurring_duration)
	return BULLET_ACT_HIT

/obj/item/storage/fancy/spywatchammobox
	name = "'Scylla's Kiss' 2mm mollusk toxin box"
	desc = "A small box containing a handful of tiny bullets. Each one is coated with the venom of the infamous zyn snail."
	icon = 'icons/obj/storage/donk_storage.dmi'
	icon_state = "box_snailtox"
	base_icon_state = "box_snailtox"
	contents_tag = "bullet"
	w_class = WEIGHT_CLASS_SMALL
	spawn_type = /obj/item/ammo_casing/spywatch
	spawn_count = 4
	storage_type = /datum/storage/spywatchammobox

///Action that lets you fire the spy watch
/datum/action/cooldown/mob_cooldown/fire_spywatch
	name = "Fire Spy Watch"
	desc = "Fire the spy watch at a clicked position."
	cooldown_time = 0 SECONDS

/datum/action/cooldown/mob_cooldown/fire_spywatch/Activate(atom/target_atom)

	var/obj/item/spywatch/spywatch_to_fire = target
	spywatch_to_fire.try_fire(target_atom, owner)
	return TRUE




/// A syndicate watch that returns its wearer to where they were a few seconds ago.
/obj/item/rewind_watch
	name = "temporal rewind watch"
	desc = "A compact watch that remembers where you have been."
	slot_flags = ITEM_SLOT_L_TRINKET | ITEM_SLOT_R_TRINKET
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "watch"
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/cooldown/mob_cooldown/rewind_watch)

	/// Maximum amount of time back in the position history the watch can rewind.
	var/rewind_duration = 4 SECONDS
	/// How frequently a direct carrier's turf is sampled.
	var/sample_interval = 0.2 SECONDS
	/// The cooldown applied after a rewind is accepted.
	var/cooldown_time = 1 SECONDS

	/// Filter key prefix. The instance-specific suffix is added in Initialize().
	var/filter_name = "rewind_watch_color"
	/// Priority of the temporary color filter on the carrier.
	var/filter_priority = 2
	/// Matrix used before and after the visual effect.
	var/list/base_color_matrix = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	/// Matrix used for the white flash.
	var/list/white_color_matrix = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0.75,0.75,0.75,0)
	/// Matrix used for the bright-blue flash.
	var/list/blue_color_matrix = list(0.35,0,0,0, 0,0.55,0,0, 0,0,1.05,0, 0,0,0,1, 0.05,0.05,0.1,0)
	/// Time spent transitioning from the base matrix to white.
	var/white_windup_time = 0.25 SECONDS
	/// Time spent transitioning from white to blue before teleporting.
	var/blue_windup_time = 0.2 SECONDS
	/// Time to remain fully blue before the teleport occurs.
	var/blue_hold_time = 0.1 SECONDS
	/// Time to remain fully blue after the teleport before resolving the arrival effect.
	var/blue_arrival_hold_time = 0.1 SECONDS
	/// Time spent transitioning from blue back to white after teleporting.
	var/white_arrival_time = 0.1 SECONDS
	/// Time spent transitioning from white back to the base matrix.
	var/base_arrival_time = 0.5 SECONDS
	/// Easing used while building the departure effect.
	var/windup_easing = CUBIC_EASING | EASE_IN
	/// Easing used while resolving the arrival effect.
	var/arrival_easing = CUBIC_EASING | EASE_OUT

	/// Sound played at the departure turf.
	var/departure_sound = SFX_PORTAL_ENTER
	/// Sound played at the arrival turf after a successful teleport.
	var/arrival_sound = SFX_PORTAL_ENTER
	/// Volume used for both teleport sounds.
	var/sound_volume = 50

	/// The mob currently carrying the watch directly.
	var/mob/living/tracked_carrier
	/// Timestamped turf samples, oldest first.
	var/list/position_history = list()
	/// Accumulator used to sample at sample_interval despite subsystem timing.
	var/sample_elapsed = 0
	/// Instance-specific filter name, preventing two watches from sharing a filter.
	var/instance_filter_name
	/// Whether a rewind is currently in its visual/teleport sequence.
	var/rewind_in_progress = FALSE
	/// Carrier currently undergoing the visual/teleport sequence.
	var/mob/living/rewind_carrier
	/// Destination captured when the action was activated.
	var/turf/rewind_destination
	/// Timer that performs the teleport at the end of the wind-up.
	var/rewind_timer
	/// Timer for the post-teleport hold or filter cleanup.
	var/cleanup_timer

/obj/item/rewind_watch/Initialize(mapload)
	. = ..()
	instance_filter_name = "[filter_name]_[REF(src)]" //incase some guy decides he wants two rewind watches
	RegisterSignal(src, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(on_post_unequip))

/obj/item/rewind_watch/Destroy(force)
	STOP_PROCESSING(SSfastprocess, src)
	UnregisterSignal(src, COMSIG_ITEM_POST_UNEQUIP)
	if(rewind_timer)
		deltimer(rewind_timer)
		rewind_timer = null
	if(cleanup_timer)
		deltimer(cleanup_timer)
		cleanup_timer = null
	cleanup_rewind_effect()
	return ..()

/obj/item/rewind_watch/proc/on_post_unequip(obj/item/source, force, atom/newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER

	if(newloc == tracked_carrier)
		return
	STOP_PROCESSING(SSfastprocess, src)
	reset_position_history()
	tracked_carrier = null

/obj/item/rewind_watch/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(tracked_carrier && tracked_carrier != user)
		reset_position_history()
	var/new_carrier = tracked_carrier != user
	tracked_carrier = istype(user, /mob/living) ? user : null
	if(tracked_carrier)
		if(new_carrier)
			record_position_sample()
		sample_elapsed = 0
		START_PROCESSING(SSfastprocess, src)

/obj/item/rewind_watch/proc/record_position_sample()
	var/turf/current_turf = get_turf(tracked_carrier)
	if(!current_turf)
		return
	position_history += list(list("time" = world.time, "turf" = current_turf))
	// Samples are appended chronologically; discard stale entries from the front
	// so the history remains bounded to the maximum rewind window.
	var/oldest_allowed_time = world.time - rewind_duration - sample_interval
	while(length(position_history) && position_history[1]["time"] < oldest_allowed_time)
		position_history.Cut(1, 2)

/obj/item/rewind_watch/process(seconds_per_tick)
	if(!tracked_carrier || QDELETED(tracked_carrier))
		reset_position_history()
		tracked_carrier = null
		return PROCESS_KILL

	sample_elapsed += seconds_per_tick
	if(sample_elapsed < sample_interval)
		return
	sample_elapsed = 0
	record_position_sample()

/// Clears all remembered positions and resets the sampling clock.
/obj/item/rewind_watch/proc/reset_position_history()
	position_history.Cut()
	sample_elapsed = 0

/// Gets the most recent sample at or before the rewind target time, or the oldest
/// available sample when the watch has not been worn for the full rewind duration.
/obj/item/rewind_watch/proc/get_rewind_destination()
	if(!length(position_history))
		return
	var/target_time = world.time - rewind_duration
	var/turf/selected_turf
	for(var/list/sample as anything in position_history)
		if(sample["time"] > target_time)
			break
		selected_turf = sample["turf"]
	return selected_turf || position_history[1]["turf"]

/// Starts the rewind sequence for the action's owner.
/obj/item/rewind_watch/proc/activate_rewind(mob/living/user)
	if(!user || QDELETED(user) || rewind_in_progress || tracked_carrier != user || loc != user)
		return FALSE

	var/turf/destination = get_rewind_destination()
	if(!destination || QDELETED(destination))
		balloon_alert(user, "the watch has not recorded your position yet")
		return FALSE

	rewind_in_progress = TRUE
	rewind_carrier = user
	rewind_destination = destination
	user.add_filter(instance_filter_name, filter_priority, color_matrix_filter(base_color_matrix))
	var/rewind_filter = user.get_filter(instance_filter_name)
	if(!rewind_filter)
		cleanup_rewind_effect()
		return FALSE

	animate(rewind_filter, color = white_color_matrix, time = white_windup_time, easing = windup_easing)
	animate(color = blue_color_matrix, time = blue_windup_time, easing = windup_easing)
	rewind_timer = addtimer(CALLBACK(src, PROC_REF(perform_rewind)), white_windup_time + blue_windup_time + blue_hold_time, TIMER_STOPPABLE)
	return TRUE

/// Performs the teleport at the visual effect's midpoint.
/obj/item/rewind_watch/proc/perform_rewind()
	rewind_timer = null
	var/mob/living/user = rewind_carrier
	var/turf/destination = rewind_destination
	if(!user || QDELETED(user) || user.stat == DEAD || !destination || QDELETED(destination))
		finish_rewind_effect()
		return

	var/turf/departure = get_turf(user)
	if(departure)
		playsound(departure, departure_sound, sound_volume, TRUE)

	var/teleported = do_teleport(user, destination)
	if(teleported)
		var/turf/arrival = get_turf(user)
		if(arrival)
			playsound(arrival, arrival_sound, sound_volume, TRUE)

	if(blue_arrival_hold_time)
		cleanup_timer = addtimer(CALLBACK(src, PROC_REF(start_arrival_animation)), blue_arrival_hold_time, TIMER_STOPPABLE)
	else
		start_arrival_animation()

/// Starts the blue-to-white-to-base portion of the arrival effect after its blue hold.
/obj/item/rewind_watch/proc/start_arrival_animation()
	cleanup_timer = null
	var/mob/living/user = rewind_carrier
	if(!user || QDELETED(user))
		finish_rewind_effect()
		return

	var/rewind_filter = user.get_filter(instance_filter_name)
	if(!rewind_filter)
		finish_rewind_effect()
		return
	animate(rewind_filter, color = white_color_matrix, time = white_arrival_time, easing = arrival_easing)
	animate(color = base_color_matrix, time = base_arrival_time, easing = arrival_easing)
	cleanup_timer = addtimer(CALLBACK(src, PROC_REF(finish_rewind_effect)), white_arrival_time + base_arrival_time, TIMER_STOPPABLE)

/// Removes the temporary filter and clears all in-progress state.
/obj/item/rewind_watch/proc/finish_rewind_effect()
	cleanup_timer = null
	cleanup_rewind_effect()

/obj/item/rewind_watch/proc/cleanup_rewind_effect()
	if(rewind_timer)
		deltimer(rewind_timer)
		rewind_timer = null
	if(cleanup_timer)
		deltimer(cleanup_timer)
		cleanup_timer = null
	if(rewind_carrier && !QDELETED(rewind_carrier))
		rewind_carrier.remove_filter(instance_filter_name)
	rewind_in_progress = FALSE
	rewind_carrier = null
	rewind_destination = null


/// Action button that returns the watch's carrier to their recorded turf.
/datum/action/cooldown/mob_cooldown/rewind_watch
	name = "Rewind Time"
	desc = "Return to the position you occupied four seconds ago."
	cooldown_time = 8 SECONDS
	click_to_activate = FALSE
	button_icon = 'icons/obj/weapons/guns/ballistic.dmi'
	button_icon_state = "watch"

/datum/action/cooldown/mob_cooldown/rewind_watch/Activate(atom/target_atom)
	var/obj/item/rewind_watch/watch = target
	if(!istype(watch) || !isliving(owner))
		return FALSE
	var/mob/living/user = owner
	if(!watch.activate_rewind(user))
		return FALSE
	StartCooldown(watch.cooldown_time)
	return TRUE
