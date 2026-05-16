/**
 * A bag of dry concrete mix. Used as an ingredient in the concrete mixer.
 * Obtained by crafting, cargo, or other means (not in scope for initial implementation).
 */
/obj/item/concrete_mix
	name = "bag of concrete mix"
	desc = "A bag of dry concrete mix. Add water and stir."
	icon = 'icons/obj/donk_structures/cement.dmi'
	icon_state = "cement"
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 5
	throw_speed = 2
	throw_range = 5

/// A dense concrete block cast from a mould. Heavy and inert; used as ballast or a construction material.
/obj/item/concrete_sow
	name = "concrete sow"
	desc = "A solid block of poured concrete, still warm from the mould."
	icon = 'icons/obj/donk_structures/industrials.dmi'
	icon_state = "concrete_sow"
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 20
	throw_speed = 1
	throw_range = 2
	force = 15
