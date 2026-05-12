/**
 * Wooden mould for casting concrete objects.
 *
 * Fill with the required number of shovel loads (shovel_concrete_load component).
 * Once full, starts the concrete_drying timer → on completion, spawns `dry_result`
 * and qdels the mould.
 *
 * Subtype concrete_mould/platform: casts a /obj/structure/platform/concrete.
 */
/obj/structure/concrete_mould
	name = "concrete mould"
	desc = "A wooden mould for casting concrete. Fill it with a loaded shovel."
	icon = 'icons/obj/structures.dmi'
	icon_state = "concrete_mould" // TODO: add icon state to structures.dmi
	density = TRUE
	anchored = TRUE
	max_integrity = 50
	/// Shovel loads required to fill this mould
	var/required_units = 1
	/// Shovel loads currently in the mould
	var/filled_units = 0
	/// Type to spawn once drying finishes; must be set by each subtype
	var/dry_result = null
	/// Time until the filled mould hardens
	var/mould_harden_time = 5 MINUTES

/obj/structure/concrete_mould/examine(mob/user)
	. = ..()
	. += span_notice("It is [filled_units]/[required_units] full of concrete.")
	if(filled_units >= required_units)
		. += span_notice("It is full and curing — leave it alone for a while.")

/obj/structure/concrete_mould/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.tool_behaviour != TOOL_SHOVEL)
		return ..()

	if(filled_units >= required_units)
		user.balloon_alert(user, "mould is full")
		return ITEM_INTERACT_BLOCKING

	var/datum/component/shovel_concrete_load/load = tool.GetComponent(/datum/component/shovel_concrete_load)
	if(!load)
		user.balloon_alert(user, "no concrete on shovel")
		return ITEM_INTERACT_BLOCKING

	qdel(load)
	filled_units++
	user.balloon_alert(user, "[filled_units]/[required_units]")
	playsound(src, 'sound/effects/slosh.ogg', 50, TRUE)

	if(filled_units >= required_units)
		user.balloon_alert(user, "mould full, leave to cure")
		AddComponent(/datum/component/concrete_drying, dry_result, mould_harden_time)

	return ITEM_INTERACT_SUCCESS

/**
 * Casts a /obj/structure/platform/concrete.
 * Craft from 5 wood sheets (see sheet_types.dm).
 */
/obj/structure/concrete_mould/platform
	name = "concrete platform mould"
	desc = "A wooden mould shaped for a platform slab. Fill with three shovel loads of wet concrete."
	icon_state = "concrete_mould_platform" // TODO: add icon state to structures.dmi
	required_units = 3
	dry_result = /obj/structure/platform/concrete
