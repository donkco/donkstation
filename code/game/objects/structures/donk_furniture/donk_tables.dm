
// ----------- TABLES ---------------------------------------
// TO DO:
// * Set sensible smoothing groups to prevent janky smoothing
// * Adjust pixel_z offset for narrow tables.
// * Make tables / desks / credenzas constructible when possible. Possible with new woods materials?
// * Add new mechanics for desks, such as internal storage?
// * Make credenzas tile border objects like directional windows to prevent them from hogging space?
//-------------------------------------------------------------


/obj/structure/table/wood/teak
	name = "teak table"
	desc = "A low table made of chocolatey teak."

	icon = 'icons/obj/smooth_structures/donk_tables/table_teak.dmi'
	icon_state = "table_teak-0"
	base_icon_state = "table_teak"

	can_flip = FALSE


//----------- COARSE TABLES ------------------------------
// Tables that don't smooth.
//-----------------------------------------------------------------------------------
/obj/structure/table/round
	name = "round table"
	desc = "An example of smooth design."

	icon = 'icons/obj/donk_furniture/coarse_tables.dmi'
	icon_state = "round-teak"
	base_icon_state = "round-teak"
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null

	frame = /obj/structure/table_frame/wood
	framestack = /obj/item/stack/sheet/mineral/wood
	buildstack = /obj/item/stack/sheet/mineral/wood

	resistance_flags = FLAMMABLE
	max_integrity = 70

	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)

	can_flip = FALSE

/obj/structure/table/round/marble
	name = "marble table"
	desc = "Maybe this once held Marie Antionette's powder box."

	icon_state = "round-marble"
	base_icon_state = "round-marble"

	buildstack = /obj/item/stack/sheet/marble

	custom_materials = list(/datum/material/rock/marble = SHEET_MATERIAL_AMOUNT)

/obj/structure/table/shelves
	name = "shelves"
	desc = "Multi-level storage, we really are in the space age!"

	icon = 'icons/obj/donk_furniture/coarse_tables.dmi'
	icon_state = "shelves-grey"
	base_icon_state = "shelves-grey"
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null

	frame = /obj/structure/table_frame
	framestack = /obj/item/stack/rods
	buildstack = /obj/item/stack/sheet/iron

	can_flip = FALSE

//-------- ROLLING TABLES----------------------------------
// Tables that roll, like the famous rolly-polyrolling table.
//----------------------------------------------------------

/obj/structure/table/rolling/tool_cart
	name = "tool cart"
	desc = "A little cart with its little wheels."

	icon = 'icons/obj/donk_furniture/coarse_tables.dmi'
	icon_state = "cart-tool"


// ----------- DESKS ---------------------------------------
//-------------------------------------------------------------

/obj/structure/table/desk
	name = "desk"
	desc = "A desk. For stationary use."

	icon = 'icons/obj/smooth_structures/donk_tables/desk_steelcase_white_green.dmi'
	icon_state = "desk_steelcase_white_green-0"
	base_icon_state = "desk_steelcase_white_green"

	can_flip = FALSE

/obj/structure/table/desk/fancy_wood
	name = "rosewood desk"
	desc = "An important title on the door is a sure sign of fine, endangered hardwoods within."

	icon = 'icons/obj/smooth_structures/donk_tables/desk_rosewood.dmi'
	icon_state = "desk_rosewood-0"
	base_icon_state = "desk_rosewood"

	resistance_flags = FLAMMABLE

	frame = /obj/structure/table_frame/wood
	framestack = /obj/item/stack/sheet/mineral/wood
	buildstack = /obj/item/stack/sheet/mineral/wood
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)

//TODO: Isolate into smoothing groups

// --------------- CREDENZAS ---------------------------------
//-------------------------------------------------------------


/obj/structure/table/credenza
	name = "credenza"
	desc = "A little cabinet for the display of various treasures and trinkets."

	icon = 'icons/obj/smooth_structures/donk_tables/credenza_teak_slider.dmi'
	icon_state = "credenza_teak_slider-0"
	base_icon_state = "credenza_teak_slider"

	frame = /obj/structure/table_frame/wood
	framestack = /obj/item/stack/sheet/mineral/wood
	buildstack = /obj/item/stack/sheet/mineral/wood
	resistance_flags = FLAMMABLE
	max_integrity = 70
//	smoothing_groups = SMOOTH_GROUP_WOOD_TABLES
//	canSmoothWith = SMOOTH_GROUP_WOOD_TABLES
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)
	can_flip = FALSE

/obj/structure/table/credenza/twin_doors

	icon = 'icons/obj/smooth_structures/donk_tables/credenza_teak_twin_doors.dmi'
	icon_state = "credenza_teak_twin_doors-0"
	base_icon_state = "credenza_teak_twin_doors"

/obj/structure/table/credenza/twin_doors

	icon = 'icons/obj/smooth_structures/donk_tables/credenza_teak_cabinet_drawers.dmi'
	icon_state = "credenza_teak_cabinet_drawers-0"
	base_icon_state = "credenza_teak_cabinet_drawers"
