// PLATFORMs
/obj/structure/platform/concrete
	name = "concrete platform"
	desc = "A concrete slab raised above the rest."

	icon = 'icons/obj/smooth_structures/donk_platforms/platform_concrete.dmi'
	icon_state = "platform_concrete"

	custom_materials = list(/datum/material/concrete = SHEET_MATERIAL_AMOUNT * 2)
	max_integrity = 250
	resistance_flags = FIRE_PROOF | FREEZE_PROOF
	footstep = FOOTSTEP_CONCRETE

// STEPS & RAMPS

/obj/structure/steps/concrete_ramp
	name = "concrete ramp"
	desc = "A steep but sturdy ramp."
	icon = 'icons/obj/donk_structures/donk_stairs.dmi'
	icon_state = "concrete_ramp"
	anchored = TRUE
	move_resist = INFINITY
	custom_materials = list(/datum/material/concrete = SHEET_MATERIAL_AMOUNT)
	///  base_pixel_offsets for the different dirs(x,y)
	var/static/list/dir_offsets = list(
		TEXT_SOUTH = list(0, 1),
		TEXT_EAST = list(2, 0),
		TEXT_NORTH = list(0, -8),
		TEXT_WEST = list(-2, 0),
	)

/obj/structure/steps/concrete_ramp/Initialize(mapload)
	. = ..()
	// set the pixel offsets based on the direction the ramp is facing
	if((dir in dir_offsets) && !mapload)
		SET_BASE_PIXEL(dir_offsets[dir]dir_offsets[1], dir_offsets[dir][2])

/obj/structure/steps/concrete_ramp/setDir(newdir)
	. = ..()
	if(newdir in dir_offsets)
		SET_BASE_PIXEL(dir_offsets[newdir][1], dir_offsets[newdir][2])

/obj/structure/steps/concrete_ramp/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	return NONE

/obj/structure/steps/concrete_ramp/wrench_act(mob/living/user, obj/item/tool)
	return

/obj/structure/steps/concrete_ramp/screwdriver_act(mob/living/user, obj/item/tool)
	return

/obj/structure/steps/concrete_ramp/atom_deconstruct(disassembled = TRUE)
	return
