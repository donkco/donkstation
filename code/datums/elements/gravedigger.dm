/// Data holder for a turf's grave type, fill soil, and forensics sample text.
/// Never instantiated — vars are read via :: operator.
/datum/grave_turf_data
	var/grave_type
	var/soil_type
	var/sample_text

/datum/grave_turf_data/ash
	grave_type = /obj/structure/closet/crate/grave/fresh/ash
	soil_type = /obj/item/stack/ore/glass/basalt
	sample_text = "Specks of volcanic ash"

/datum/grave_turf_data/ash/ashplanet
	sample_text = "Traces of ash"

/datum/grave_turf_data/sand
	grave_type = /obj/structure/closet/crate/grave/fresh/sand
	soil_type = /obj/item/stack/ore/glass
	sample_text = "Grains of asteroid sand"

/datum/grave_turf_data/sand/sandy_dirt
	sample_text = "Grains of sand"

/datum/grave_turf_data/dirt
	grave_type = /obj/structure/closet/crate/grave/fresh
	soil_type = /obj/item/stack/ore/glass/dirt
	sample_text = "Clumps of dirt"

/datum/grave_turf_data/snow
	grave_type = /obj/structure/closet/crate/grave/fresh/snow
	soil_type = /obj/item/stack/ore/snow
	sample_text = "Traces of snow"

/**
 * Gravedigger element. Allows for graves to be dug from certain tiles.
 * Spawns a turf-appropriate grave subtype and fill material,
 * and adds a soil sample to the tool's forensics.
 */
/datum/element/gravedigger
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2

	/**
	 * Assoc list mapping turf type paths to /datum/grave_turf_data subtypes.
	 * Listed most-specific first so istype() matching finds the right subtype.
	 */
	var/static/list/turf_grave_data = list(
		/turf/open/misc/asteroid/basalt = /datum/grave_turf_data/ash,
		/turf/open/misc/basalt			= /datum/grave_turf_data/ash,
		/turf/open/misc/ashplanet       = /datum/grave_turf_data/ash/ashplanet,
		/turf/open/misc/asteroid        = /datum/grave_turf_data/sand,
		/turf/open/misc/asteroid/snow   = /datum/grave_turf_data/snow,
		/turf/open/misc/sandy_dirt      = /datum/grave_turf_data/sand/sandy_dirt,
		/turf/open/misc/dirt            = /datum/grave_turf_data/dirt,
		/turf/open/misc/grass           = /datum/grave_turf_data/dirt,
		/turf/open/misc/snow            = /datum/grave_turf_data/snow,
	)

	/// Lazily-initialized typecache built from the keys of turf_grave_data
	var/static/list/turfs_typecache

/datum/element/gravedigger/Attach(datum/target)
	. = ..()

	if(!isitem(target)) //Must be an item to use toolspeed variable.
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ITEM_INTERACTING_WITH_ATOM_SECONDARY, PROC_REF(dig_checks))
	RegisterSignal(target, COMSIG_ITEM_REQUESTING_CONTEXT_FOR_TARGET, PROC_REF(on_context_request))

/datum/element/gravedigger/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, list(
		COMSIG_ITEM_INTERACTING_WITH_ATOM_SECONDARY,
		COMSIG_ITEM_REQUESTING_CONTEXT_FOR_TARGET,
	))

/// Returns the lazily-initialized typecache for all diggable turf types
/datum/element/gravedigger/proc/get_turfs_typecache()
	if(isnull(turfs_typecache))
		var/list/turf_types = list()
		for(var/turf_type in turf_grave_data)
			turf_types += turf_type
		turfs_typecache = typecacheof(turf_types)
	return turfs_typecache

/// Returns the /datum/grave_turf_data subtype matching the given turf, or null
/datum/element/gravedigger/proc/get_grave_data_for_turf(turf/t)
	for(var/turf_type in turf_grave_data)
		if(istype(t, turf_type))
			return turf_grave_data[turf_type]
	return null

/datum/element/gravedigger/proc/dig_checks(datum/source, mob/living/user, atom/interacting_with, list/modifiers)
	SIGNAL_HANDLER

	if(!is_type_in_typecache(interacting_with, get_turfs_typecache()))
		return NONE

	if(locate(/obj/structure/closet/crate/grave) in interacting_with)
		return NONE //Already is a grave, so don't do anything

	user.balloon_alert(user, "digging grave...")
	playsound(interacting_with, 'sound/effects/shovel_dig.ogg', 50, TRUE)
	INVOKE_ASYNC(src, PROC_REF(perform_digging), user, interacting_with, source)
	return ITEM_INTERACT_BLOCKING

/datum/element/gravedigger/proc/perform_digging(mob/user, turf/dig_turf, obj/item/our_tool)
	if(!our_tool.use_tool(dig_turf, user, 10 SECONDS * (HAS_MIND_TRAIT(user, TRAIT_MORBID) ? 0.7 : 1) * our_tool.toolspeed))
		return

	var/datum/grave_turf_data/data_type = get_grave_data_for_turf(dig_turf)
	if(!data_type)
		return

	var/obj/grave_type = data_type::grave_type
	var/obj/soil_type = data_type::soil_type

	new grave_type(dig_turf)
	new soil_type(dig_turf)
	our_tool.add_soil_sample(data_type::sample_text)

/// Screentip handler: shows "Dig grave" RMB hint when hovering a valid diggable turf with no grave
/datum/element/gravedigger/proc/on_context_request(obj/item/source, list/context, atom/target, mob/user)
	SIGNAL_HANDLER

	if(!is_type_in_typecache(target, get_turfs_typecache()))
		return NONE

	if(locate(/obj/structure/closet/crate/grave) in target)
		return NONE

	context[SCREENTIP_CONTEXT_RMB] = "Dig grave"
	return CONTEXTUAL_SCREENTIP_SET

