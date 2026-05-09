/obj/structure/closet/crate/cardboard
	name = "cardboard box"
	desc = "A box, in which you can place things. Revolutionary, I know."
	material_drop = /obj/item/stack/sheet/cardboard
	material_drop_amount = 4
	custom_materials = list(/datum/material/cardboard = SHEET_MATERIAL_AMOUNT * 4)
	icon_state = "cardboard"
	base_icon_state = "cardboard"
	open_sound = 'sound/items/poster/poster_ripped.ogg'
	close_sound = 'sound/machines/cardboard_box.ogg'
	open_sound_volume = 25
	close_sound_volume = 25
	paint_jobs = null
	cutting_tool = /obj/item/wirecutters
	can_weld_shut = FALSE
	lid_icon_state = "cardboardopen"

/// Filling the box with packing peanuts protects sensitive contents from nearby explosion shockwaves.
/obj/structure/closet/crate/cardboard/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/packing_peanuts))
		return ..()
	if(flags_1 & PREVENTS_CONTENTS_SENSITIVE_OBJECT_DESTRUCTION)
		balloon_alert(user, "already padded!")
		return ITEM_INTERACT_SUCCESS
	user.transferItemToLoc(tool, null)
	qdel(tool)
	flags_1 |= PREVENTS_CONTENTS_SENSITIVE_OBJECT_DESTRUCTION
	balloon_alert(user, "filled with packing peanuts")
	return ITEM_INTERACT_SUCCESS

/obj/structure/closet/crate/cardboard/mothic
	name = "\improper Mothic Fleet box"
	desc = "For holding moths, presumably."
	icon_state = "cardboard_moth"
	base_icon_state = "cardboard_moth"

/obj/structure/closet/crate/cardboard/tiziran
	name = "\improper Tiziran shipment box"
	desc = "For holding lizards, presumably."
	icon_state = "cardboard_tiziran"
	base_icon_state = "cardboard_tiziran"

/obj/structure/closet/crate/cardboard/update_icon_state()
	. = ..()
	if(opened)
		icon_state = "[base_icon_state]"
