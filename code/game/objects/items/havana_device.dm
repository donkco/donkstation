/// Looping bass tone — 1s loop, heavy falloff (felt close-up)
/datum/looping_sound/havana_device/primary
	mid_sounds = list('sound/items/havana/havana_bass.ogg' = 1)
	mid_length = 0.75 SECONDS
	volume = 50
	falloff_distance = 5
	falloff_exponent = 7
	ignore_walls = TRUE

/// Looping ambient buzz — 0.75s loop, low falloff (wide area ambience)
/datum/looping_sound/havana_device/secondary
	mid_sounds = list('sound/items/havana/havana_buzz.ogg' = 1)
	mid_length = 0.75 SECONDS
	volume = 10
	falloff_distance = 7
	falloff_exponent = 3
	ignore_walls = TRUE

/datum/movespeed_modifier/havana_slowdown
	variable = TRUE
	multiplicative_slowdown = 0.1


/atom/movable/warp_effect/sound_wave
	plane = DISPLACEMENT_PLANE
	appearance_flags = PIXEL_SCALE // no tile bound so you can see it around corners and so
	icon = 'icons/effects/384x384.dmi'
	icon_state = "sound_waves_displacement"
	pixel_x = -176
	pixel_y = -176


/*
 * The Havana Device — held briefcase form.
 * Use in-hand to deploy the acoustic emitter on the ground.
 */
/obj/item/havana_device
	name = "Havana device"
	desc = "A nondescript briefcase. It hums faintly"
	icon = 'icons/obj/storage/case.dmi'
	icon_state = "briefcase"
	inhand_icon_state = "briefcase"
	lefthand_file = 'icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/briefcase_righthand.dmi'
	force = 8
	w_class = WEIGHT_CLASS_BULKY
	throw_speed = 2
	throw_range = 4
	attack_verb_continuous = list("bashes", "batters", "bludgeons")
	attack_verb_simple = list("bash", "batter", "bludgeon")

	///How long when arming before the briefcase deploys the emitter on the ground
	var/deployment_time = 3 SECONDS

/obj/item/havana_device/attack_self(mob/user)
	user.visible_message(
		span_warning("[user] flips open a panel on [src] — a faint, arming whine begins."),
		span_notice("You begin arming the Havana device. It will deploy in [deployment_time] seconds.")
	)
	playsound(user, 'sound/items/weapons/armbomb.ogg', 75, TRUE, -3)
	addtimer(CALLBACK(src, PROC_REF(deploy), user), deployment_time)

/// Deploy the structure at the current location of the device.
/obj/item/havana_device/proc/deploy(mob/living/user)
	var/turf/deploy_turf = get_turf(src)
	if(!deploy_turf)
		return
	new /obj/structure/havana_device(deploy_turf, user)
	deploy_turf.visible_message(span_warning("The Havana device clicks into place and begins emitting a discordant hum!"))
	qdel(src)

/*
 * Deployed version of the havana device
 * Pulses status effects on all living mobs within the range, closer to the center? you get more fucked up.
 * Scales linearly towards the center, and unblocked by walls.
 * The deployer can retrieve it instantly; anyone else takes 4 seconds.
 */
/obj/structure/havana_device
	name = "Havana device"
	desc = "An open briefcase with exposed circuitry inside. A low, nauseating tone radiates from it."
	icon = 'icons/obj/storage/case.dmi'
	icon_state = "briefcase"
	density = TRUE
	anchored = TRUE
	max_integrity = 100

	/// The mob who deployed this — can retrieve it without a doafter.
	var/mob/living/deployer
	/// Mobs currently inside the effect radius that have the slowdown modifier.
	var/list/affected_mobs = list()
	/// Effect radius in tiles.
	var/pulse_range = 10
	/// Looping bass tone datum.
	var/datum/looping_sound/havana_device/primary/sound_primary
	/// Looping ambient buzz datum.
	var/datum/looping_sound/havana_device/secondary/sound_secondary
	/// Displacement warp effect shown while the device is active.
	var/atom/movable/warp_effect/sound_wave/warp

	/// Max eye blur in seconds.
	var/blur_max = 15 SECONDS
	/// Blur adjustment multiplier per second at max intensity.
	var/blur_intensity = 3 SECONDS

	/// Max confusion in seconds.
	var/confusion_max = 15 SECONDS
	/// Confusion adjustment multiplier per second at max intensity.
	var/confusion_intensity = 3 SECONDS

	/// Max disgust amount.
	var/disgust_max = DISGUST_LEVEL_MAXEDOUT
	/// Disgust adjustment multiplier per second at max intensity.
	var/disgust_intensity = 20

	/// Slowdown multiplier (multiplicative_slowdown) at max intensity.
	var/slowdown_intensity = 4

/obj/structure/havana_device/Initialize(mapload, mob/living/who)
	. = ..()
	deployer = who
	sound_primary = new(src, TRUE)
	sound_secondary = new(src, TRUE)
	warp = new(src)
	vis_contents += warp
	START_PROCESSING(SSobj, src)

/obj/structure/havana_device/Destroy()
	for(var/mob/living/victim in affected_mobs)
		victim.remove_movespeed_modifier(/datum/movespeed_modifier/havana_slowdown)
	affected_mobs = list()
	QDEL_NULL(sound_primary)
	QDEL_NULL(sound_secondary)
	if(warp)
		vis_contents -= warp
		QDEL_NULL(warp)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/havana_device/attack_hand(mob/user, list/params)
	. = ..()
	if(.)
		return
	if(user == deployer)
		retrieve(user)
		return
	user.balloon_alert(user, "prying it open...")
	if(!do_after(user, 4 SECONDS, src))
		return
	retrieve(user)

/// Shut down the emitter and give the item back to [retriever].
/obj/structure/havana_device/proc/retrieve(mob/living/retriever)
	var/obj/item/havana_device/item = new(get_turf(src))
	retriever.put_in_hands(item)
	retriever.visible_message(
		span_warning("[retriever] scoops up the Havana device — the hum cuts out."),
		span_notice("You retrieve the Havana device.")
	)
	qdel(src)

/obj/structure/havana_device/process(seconds_per_tick)
	var/list/current_targets = list()

	for(var/mob/living/target in range(pulse_range, src))
		if(target.stat == DEAD)
			continue
		var/dist = get_dist(target, src)
		// intensity: 1.0 at centre, ~0.125 at the edge (range 7)
		var/intensity = (pulse_range - dist + 1) / (pulse_range + 1)

		target.adjust_eye_blur_up_to(round(intensity * blur_intensity * seconds_per_tick), blur_max)
		target.adjust_confusion_up_to(round(intensity * confusion_intensity * seconds_per_tick), confusion_max)
		if(iscarbon(target))
			var/mob/living/carbon/carbon_target = target
			carbon_target.adjust_disgust(round(intensity * disgust_intensity * seconds_per_tick), disgust_max)
		target.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/havana_slowdown, TRUE, multiplicative_slowdown = intensity * slowdown_intensity)

		current_targets += target

	// Clean up anyone who left the radius
	for(var/mob/living/gone in affected_mobs)
		if(!(gone in current_targets))
			gone.remove_movespeed_modifier(/datum/movespeed_modifier/havana_slowdown)
	affected_mobs = current_targets
