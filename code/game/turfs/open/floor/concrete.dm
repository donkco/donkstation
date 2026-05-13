/**
 * Wet concrete — freshly poured, hardens after `harden_time` into dry concrete.
 */
/turf/open/floor/concrete/wet
	name = "wet concrete"
	desc = "Freshly poured concrete. It'll harden soon."
	icon = 'icons/turf/floors/wet_concrete.dmi'
	icon_state = "wet_concrete-0"
	base_icon_state = "wet_concrete"
	footstep = FOOTSTEP_MEAT
	barefootstep = FOOTSTEP_MEAT
	clawfootstep = FOOTSTEP_MEAT
	heavyfootstep = FOOTSTEP_MEAT

	/// How long until this hardens into dry concrete
	var/harden_time = 1 MINUTES

/turf/open/floor/concrete/wet/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/concrete_drying, /turf/open/floor/concrete, harden_time)

/**
 * Dry (hardened) concrete — a solid floor. Can be broken up with mining tools.
 */
/turf/open/floor/concrete
	name = "concrete floor"
	desc = "Solid poured concrete."
	icon = 'icons/turf/floors/wet_concrete.dmi'
	icon_state = "wet_concrete-0" // TODO: add bitmask states to floors.dmi
	base_icon_state = "wet_concrete"
	footstep = FOOTSTEP_CONCRETE
	barefootstep = FOOTSTEP_CONCRETE
	clawfootstep = FOOTSTEP_CONCRETE
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_CONCRETE
	canSmoothWith = SMOOTH_GROUP_FLOOR_CONCRETE

/turf/open/floor/concrete/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.tool_behaviour == TOOL_MINING)
		playsound(src, 'sound/effects/pickaxe/picaxe1.ogg', 50, TRUE)
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		return ITEM_INTERACT_SUCCESS
	return ..()
