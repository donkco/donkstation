/**
 * Attached to a shovel when it scoops wet concrete from the mixer.
 *
 * On left-click with the loaded shovel:
 *   - Open turf in whitelist: pours wet concrete, qdels itself.
 *   - Open turf not in whitelist: spawns a concrete spill decal, qdels itself.
 *   - atom/movable: fires COMSIG_CONCRETE_LOAD_DEPOSIT at the target with (source, user).
 *     If the target returns CONCRETE_DEPOSIT_CONSUMED the load is consumed.
 *     Otherwise nothing happens.
 */
/datum/component/shovel_concrete_load
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/shovel_concrete_load/Initialize(mapload)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/shovel_concrete_load/RegisterWithParent()
	ADD_TRAIT(parent, TRAIT_SHOVEL_HAS_CONCRETE_LOAD, /datum/component/shovel_concrete_load)
	RegisterSignal(parent, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(on_interact))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/shovel_concrete_load/UnregisterFromParent()
	REMOVE_TRAIT(parent, TRAIT_SHOVEL_HAS_CONCRETE_LOAD, /datum/component/shovel_concrete_load)
	UnregisterSignal(parent, list(COMSIG_ITEM_INTERACTING_WITH_ATOM, COMSIG_ATOM_EXAMINE))

/datum/component/shovel_concrete_load/proc/on_interact(obj/item/source, mob/living/user, atom/interacting_with, list/modifiers)
	SIGNAL_HANDLER

	if(isopenturf(interacting_with))
		var/turf/T = interacting_with
		if(is_type_in_typecache(T, GLOB.concrete_valid_turfs))
			T.ChangeTurf(/turf/open/floor/concrete/wet, null, CHANGETURF_INHERIT_AIR)
			user.balloon_alert(user, "you pour the concrete")
			playsound(T, 'sound/effects/slosh.ogg', 50, TRUE)
			qdel(src)
			return ITEM_INTERACT_SUCCESS
		// Invalid turf: spill
		new /obj/effect/decal/cleanable/concrete_spill(T)
		user.balloon_alert(user, "you spilled the concrete!")
		playsound(T, 'sound/effects/shovel_dig.ogg', 50, TRUE)
		qdel(src)
		return ITEM_INTERACT_SUCCESS

	if(ismovable(interacting_with))
		var/result = SEND_SIGNAL(interacting_with, COMSIG_CONCRETE_LOAD_DEPOSIT, source, user)
		if(result & CONCRETE_DEPOSIT_CONSUMED)
			qdel(src)
			return ITEM_INTERACT_SUCCESS

	return NONE

/datum/component/shovel_concrete_load/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_notice("It has a load of wet concrete on it.")
