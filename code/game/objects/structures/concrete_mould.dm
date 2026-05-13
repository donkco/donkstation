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
	icon = 'icons/obj/donk_structures/cement.dmi'
	icon_state = "mould"
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

/obj/structure/concrete_mould/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_CONCRETE_LOAD_DEPOSIT, PROC_REF(on_concrete_deposit))

/obj/structure/concrete_mould/examine(mob/user)
	. = ..()
	. += span_notice("It is [filled_units]/[required_units] full of concrete.")
	if(filled_units >= required_units)
		. += span_notice("It is full and curing — leave it alone for a while.")

/obj/structure/concrete_mould/proc/on_concrete_deposit(atom/source, obj/item/shovel, mob/living/user)
	SIGNAL_HANDLER
	if(filled_units >= required_units)
		user.balloon_alert(user, "mould is full")
		return NONE

	filled_units++
	user.balloon_alert(user, "[filled_units]/[required_units]")
	playsound(src, 'sound/effects/slosh.ogg', 50, TRUE)

	if(filled_units >= required_units)
		user.balloon_alert(user, "mould full, leave to cure")
		AddComponent(/datum/component/concrete_drying, dry_result, mould_harden_time)
		update_appearance(UPDATE_ICON_STATE)

	return CONCRETE_DEPOSIT_CONSUMED

/obj/structure/concrete_mould/update_icon_state()
	. = ..()
	if(filled_units >= required_units)
		icon_state = "mould_concrete"
	else
		icon_state = "mould"

/**
 * Casts a /obj/structure/platform/concrete.
 * Craft from 5 wood sheets (see sheet_types.dm).
 */
/obj/structure/concrete_mould/platform
	name = "concrete platform mould"
	desc = "A wooden mould shaped for a platform slab. Fill with three shovel loads of wet concrete."
	required_units = 3
	dry_result = /obj/structure/platform/concrete
