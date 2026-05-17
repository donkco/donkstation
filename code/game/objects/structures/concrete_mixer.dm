/**
 * Portable concrete mixer barrel.
 *
 * FILLING:
 *   - Left-click with a bag of concrete mix → adds `mix_per_batch` units of dry mix.
 *     Combined mix + ready concrete can never exceed `max_capacity`.
 *   - Left-click with a reagent container holding water → draws water into the internal
 *     tank (up to `max_capacity` units total).
 *
 * MIXING:
 *   - Left-click with empty hands when both mix and water are loaded
 *     → 3-second work → yields `units_per_mix` units of wet concrete ready to pour.
 *     The mixer becomes anchored after mixing, preventing it from being moved.
 *
 * POURING:
 *   - Right-click → tips the barrel, flood-filling from the mixer's tile outward
 *     over whitelisted open turfs at `pour_interval` per tile.
 *     Each tick freshly scans the border of already-poured tiles for the next valid target,
 *     so tile state changes between ticks are always caught.
 *     The mixer unanchors once pouring finishes or is exhausted.
 */
/obj/structure/concrete_mixer
	name = "concrete mixer"
	desc = "A portable barrel-style concrete mixer. Fill it with a bag of concrete mix and some water, then mix and pour."
	icon = 'icons/obj/donk_structures/cement.dmi'
	icon_state = "mixer" // TODO: add icon state to structures.dmi
	density = TRUE
	anchored = FALSE
	max_integrity = 150
	/// Maximum units: caps both the water tank and the total of mix_units + concrete_units
	var/max_capacity = 50
	/// Units of dry concrete mix currently loaded (not yet mixed)
	var/mix_units = 0
	/// Number of units of pourable concrete currently ready
	var/concrete_units = 0
	/// Dry mix consumed per mix cycle (one bag = one batch)
	var/mix_per_batch = 10
	/// Water consumed per mix cycle
	var/water_per_batch = 10
	/// Time between each tile being poured (deciseconds)
	var/pour_interval = 0.3 SECONDS
	/// Assoc list (turf → TRUE) of tiles already poured in the current sequence
	var/list/pour_visited
	/// Timer ID for the next pour tick
	var/pour_timer_id

/obj/structure/concrete_mixer/Initialize(mapload)
	. = ..()
	register_context()
	create_reagents(max_capacity)

/obj/structure/concrete_mixer/examine(mob/user)
	. = ..()
	var/water = reagents.get_reagent_amount(/datum/reagent/water)
	if(mix_units > 0)
		. += span_notice("It contains [mix_units]u of dry concrete mix.")
	if(water > 0)
		. += span_notice("Its water tank holds [water]/[max_capacity]u.")
	if(concrete_units > 0)
		. += span_notice("It holds [concrete_units]u of mixed concrete ready to pour. <b>Click</b> to scoop with a shovel, or <b>right-click</b> to tip and pour.")
	else if(mix_units >= mix_per_batch && water >= water_per_batch)
		. += span_notice("Ready to mix. <b>Click or right-click</b> to start mixing.")
	else
		if(mix_units < mix_per_batch)
			. += span_notice("Add more <b>bags of concrete mix</b>.")
		if(water < water_per_batch)
			. += span_notice("Add more <b>water</b> from a container.")

/obj/structure/concrete_mixer/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	if(concrete_units > 0)
		context[SCREENTIP_CONTEXT_RMB] = "Tip and pour concrete"
		if(held_item?.tool_behaviour == TOOL_SHOVEL)
			context[SCREENTIP_CONTEXT_LMB] = "Scoop concrete"
	else if(mix_units >= mix_per_batch && reagents.get_reagent_amount(/datum/reagent/water) >= water_per_batch)
		context[SCREENTIP_CONTEXT_LMB] = "Mix concrete"
	if(held_item)
		if(istype(held_item, /obj/item/concrete_mix) && (mix_units + concrete_units + mix_per_batch <= max_capacity))
			context[SCREENTIP_CONTEXT_LMB] = "Load concrete mix"
		else if(held_item.reagents?.get_reagent_amount(/datum/reagent/water) > 0 && reagents.total_volume < max_capacity)
			context[SCREENTIP_CONTEXT_LMB] = "Pour water in"
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/concrete_mixer/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	// Load concrete mix bag
	if(istype(tool, /obj/item/concrete_mix))
		if(mix_units + concrete_units + mix_per_batch > max_capacity)
			user.balloon_alert(user, "can't fit more mix")
			return ITEM_INTERACT_BLOCKING
		mix_units += mix_per_batch
		qdel(tool)
		user.balloon_alert(user, "mix loaded ([mix_units]u)")
		return ITEM_INTERACT_SUCCESS

	// Scoop concrete with a shovel
	if(tool.tool_behaviour == TOOL_SHOVEL)
		if(concrete_units <= 0)
			user.balloon_alert(user, "nothing to scoop")
			return ITEM_INTERACT_BLOCKING
		if(HAS_TRAIT(tool, TRAIT_SHOVEL_HAS_CONCRETE_LOAD))
			user.balloon_alert(user, "already loaded")
			return ITEM_INTERACT_BLOCKING
		tool.AddComponent(/datum/component/shovel_concrete_load)
		concrete_units--
		user.balloon_alert(user, "scooped")
		playsound(src, 'sound/effects/shovel_dig.ogg', 50, TRUE)
		if(concrete_units <= 0)
			finish_pour()
		return ITEM_INTERACT_SUCCESS

	// Load water from a reagent container
	if(tool.reagents)
		var/water_amount = tool.reagents.get_reagent_amount(/datum/reagent/water)
		if(water_amount > 0)
			var/space = max_capacity - reagents.total_volume
			if(space <= 0)
				user.balloon_alert(user, "water tank full")
				return ITEM_INTERACT_BLOCKING
			var/to_take = min(water_amount, space)
			tool.reagents.remove_reagent(/datum/reagent/water, to_take)
			reagents.add_reagent(/datum/reagent/water, to_take)
			user.balloon_alert(user, "water added ([reagents.total_volume]/[max_capacity]u)")
			playsound(src, 'sound/effects/slosh.ogg', 50, TRUE)
			return ITEM_INTERACT_SUCCESS

	return ..()

/obj/structure/concrete_mixer/attack_hand(mob/living/user, list/modifiers)
	if(concrete_units > 0)
		user.balloon_alert(user, "ready — right-click to pour")
		return
	try_mix(user)

/obj/structure/concrete_mixer/attack_hand_secondary(mob/living/user, list/modifiers)
	. = ..()
	if(concrete_units > 0)
		try_pour(user)
	else
		try_mix(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/concrete_mixer/proc/try_mix(mob/living/user)
	if(mix_units < mix_per_batch)
		user.balloon_alert(user, "needs concrete mix")
		return
	if(reagents.get_reagent_amount(/datum/reagent/water) < water_per_batch)
		user.balloon_alert(user, "needs water")
		return

	user.balloon_alert(user, "mixing...")
	if(!do_after(user, 3 SECONDS, target = src))
		return

	mix_units -= mix_per_batch
	reagents.remove_reagent(/datum/reagent/water, water_per_batch)
	concrete_units += mix_per_batch
	user.balloon_alert(user, "mixed! ([concrete_units]u ready)")
	playsound(src, 'sound/effects/slosh.ogg', 80, TRUE)

/obj/structure/concrete_mixer/proc/try_pour(mob/living/user)
	if(concrete_units <= 0)
		user.balloon_alert(user, "mixer is empty!")
		return

	var/turf/T = get_turf(src)
	if(!is_type_in_typecache(T, GLOB.concrete_valid_turfs))
		// Can't pour here — spill one unit
		new /obj/effect/decal/cleanable/concrete_spill(T)
		concrete_units--
		user.balloon_alert(user, "can't pour here — spilled!")
		playsound(src, 'sound/effects/slosh.ogg', 60, TRUE)
		if(concrete_units <= 0)
			finish_pour()
		return

	anchored = TRUE
	pour_visited = list()
	pour_timer_id = addtimer(CALLBACK(src, PROC_REF(pour_next_tile)), pour_interval, TIMER_DELETE_ME)
	user.balloon_alert(user, "pouring...")

/// Each timer tick: freshly scan the border of all poured tiles for the next valid target,
/// then pour it and schedule the next tick. No frontier is maintained between ticks.
/obj/structure/concrete_mixer/proc/pour_next_tile()
	pour_timer_id = null

	if(concrete_units <= 0)
		finish_pour()
		return

	var/turf/next = null

	// First tile: use the mixer's own turf.
	if(!length(pour_visited))
		next = get_turf(src)
	else
		// Freshly scan every poured tile's cardinal neighbors for the first valid unpoured target.
		for(var/turf/poured as anything in pour_visited)
			for(var/direction in GLOB.cardinals)
				var/turf/neighbor = get_step(poured, direction)
				if(neighbor && !pour_visited[neighbor] && isopenturf(neighbor) && is_type_in_typecache(neighbor, GLOB.concrete_valid_turfs))
					next = neighbor
					break
			if(next)
				break

	if(!next || !is_type_in_typecache(next, GLOB.concrete_valid_turfs))
		finish_pour()
		return

	pour_visited[next] = TRUE
	next.ChangeTurf(/turf/open/floor/concrete/wet, flags = CHANGETURF_INHERIT_AIR)
	concrete_units--
	playsound(next, 'sound/effects/slosh.ogg', 40, TRUE)

	if(concrete_units > 0)
		pour_timer_id = addtimer(CALLBACK(src, PROC_REF(pour_next_tile)), pour_interval, TIMER_DELETE_ME)
	else
		finish_pour()

/obj/structure/concrete_mixer/proc/finish_pour()
	anchored = FALSE
	pour_visited = null
	pour_timer_id = null

/obj/structure/concrete_mixer/Destroy()
	if(pour_timer_id)
		deltimer(pour_timer_id)
		pour_timer_id = null
	pour_visited = null
	return ..()


/obj/structure/concrete_mixer/full
	concrete_units = 50
