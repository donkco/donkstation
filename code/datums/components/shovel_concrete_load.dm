/**
 * Attached to a shovel when it scoops wet concrete off a turf.
 *
 * Registers COMSIG_ITEM_INTERACTING_WITH_ATOM on the parent shovel.
 * On left-click with the loaded shovel:
 *   - Valid turf (whitelist or existing wet concrete): pours wet concrete, qdels itself.
 *   - Any other turf: spawns a concrete spill decal and qdels itself.
 *   - Non-turf target: no-op.
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

	if(!isopenturf(interacting_with))
		return NONE

	var/turf/T = interacting_with

	// Valid target: in the concrete whitelist only (cannot pour onto existing wet concrete)
	if(is_type_in_typecache(T, GLOB.concrete_valid_turfs))
		T.ChangeTurf(/turf/open/floor/concrete/wet, null, CHANGETURF_INHERIT_AIR)
		user.balloon_alert(user, "you pour the concrete")
		playsound(T, 'sound/effects/slosh.ogg', 50, TRUE)
		qdel(src)
		return ITEM_INTERACT_SUCCESS

	// Invalid target: spill the concrete and waste the load
	new /obj/effect/decal/cleanable/concrete_spill(T)
	user.balloon_alert(user, "you spilled the concrete!")
	playsound(T, 'sound/effects/shovel_dig.ogg', 50, TRUE)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/datum/component/shovel_concrete_load/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_notice("It has a load of wet concrete on it.")
