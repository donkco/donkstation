/**
 * Packing materials — protect fragile items inside crates from explosion shockwaves.
 *
 * Packing peanuts can line cardboard boxes.
 * Once applied, the crate gains SEISMIC_SAFEGUARD so its content
 * arent damaged by nearby blasts
 */
/obj/item/packing_peanut
	name = "packing peanut"
	desc = "A small piece of supple foam."
	icon = 'icons/obj/packing_peanuts.dmi'
	icon_state = "packing_peanuts1"
	base_icon_state = "packing_peanuts"
	w_class = WEIGHT_CLASS_TINY

/obj/item/packing_peanuts/Initialize(mapload)
	. = ..()
	icon_state = "[base_icon_state][rand(1, 16)]"
