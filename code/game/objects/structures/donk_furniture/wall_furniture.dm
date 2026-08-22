/obj/structure/wall_rack
	name = "wall rack"
	desc = "Advanced Rack Technology."
	icon = 'icons/obj/donk_structures/donk_wallmounts.dmi'
	icon_state = "gun_rack"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	max_integrity = 20
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)

	base_pixel_z = 15
	pixel_z = 15
	base_pixel_y = 15
	pixel_y = 15

/obj/structure/wall_rack/Initialize(mapload)
	. = ..()
	register_context()
	ADD_TRAIT(src, TRAIT_COMBAT_MODE_SKIP_INTERACTION, INNATE_TRAIT)
	if(mapload)
		find_and_mount_on_atom()

/obj/structure/wall_rack/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(isnull(held_item))
		return NONE

	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_RMB] = "Deconstruct"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/structure/wall_rack/examine(mob/user)
	. = ..()
	. += span_notice("It's held together by a couple of <b>bolts</b>.")

/obj/structure/wall_rack/wrench_act_secondary(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/wall_rack/base_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(.)
		return .

	if((tool.item_flags & ABSTRACT) || (user.combat_mode && !(tool.item_flags & NOBLUDGEON)))
		return NONE

	var/vector/placement_offset = vector(base_pixel_x,base_pixel_y,base_pixel_z)
	// Items are centered by default, but we move them if click ICON_X and ICON_Y are available
	if(LAZYACCESS(modifiers, ICON_X) && LAZYACCESS(modifiers, ICON_Y))
		// Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
		placement_offset.x += clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(ICON_SIZE_X*0.5), ICON_SIZE_X*0.5)
		placement_offset.z += clamp(text2num(LAZYACCESS(modifiers, ICON_Y)) - 16, -(ICON_SIZE_Y*0.5), ICON_SIZE_Y*0.5)

	if(!user.transfer_item_to_turf(tool, get_turf(src), silent = FALSE))
		return ITEM_INTERACT_BLOCKING

	tool.pixel_x = tool.base_pixel_x + placement_offset.x
	tool.pixel_y = tool.base_pixel_y + placement_offset.y
	tool.pixel_z = tool.base_pixel_z + placement_offset.z

	return ITEM_INTERACT_SUCCESS

/obj/structure/wall_rack/atom_deconstruct(disassembled = TRUE)
	var/obj/item/wallframe/rack/newparts = new(loc)
	transfer_fingerprints_to(newparts)

/obj/item/wallframe/rack
	name = "wall rack parts"
	result_path = /obj/structure/wall_rack

/obj/item/wallframe/rack/try_build(atom/support, mob/user)
	if(NORTH != get_dir(user, support))
		to_chat(user, span_warning("You need to mount this on a south facing wall."))
		return FALSE
	return ..()

/obj/structure/wall_rack/shelf
	name = "shelf"
	desc = "A sturdy shelf."
	icon_state = "shelf-engi"

	resistance_flags = FLAMMABLE|ACID_PROOF
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 2)

	base_pixel_z = 12
	pixel_z = 12
	base_pixel_y = 7
	pixel_y = 7
	/// The icon_state used by the ground_shadow element.
	var/shadow_state = "shadow-shelf"

/obj/structure/wall_rack/shelf/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ground_shadow, shadow_state)

/obj/structure/wall_rack/shelf/futura
	name = "futuristic shelf"

	icon_state = "shelf-futura"
	shadow_state = "shadow-shelf-deep"

/obj/structure/wall_rack/shelf/perforated
	icon_state = "shelf-perf-blue"
	shadow_state = "shadow-shelf-perf"

/obj/structure/wall_rack/shelf/medical
	name = "medical shelf"
	desc = "The ergonomic, physician assisted-design helps prevent back and shoulder problems."

	icon_state = "shelf-medical"
	shadow_state = "shadow-shelf-rounded"

/obj/structure/wall_rack/shelf/space
	name = "space shelf"

	icon_state = "shelf-space"
	shadow_state = "shadow-shelf-space"

	resistance_flags = FIRE_PROOF|ACID_PROOF
	custom_materials = list(/datum/material/alloy/plasteel = SHEET_MATERIAL_AMOUNT, /datum/material/plastic = SHEET_MATERIAL_AMOUNT)

// ########## WOOODEN SHELVING ######################

/obj/structure/wall_rack/shelf/wooden
	name = "wooden shelf"

	icon_state = "shelf-wooden"
	shadow_state = "shadow-shelf-wooden"

	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)

/obj/structure/wall_rack/shelf/wooden/rickety
	name = "rickety shelf"
	icon_state = "shelf-rickety"
	shadow_state = "shadow-shelf-rickety"

/obj/structure/wall_rack/shelf/wooden/fancy
	name = "fancy shelf"

	icon_state = "shelf-fancy"
	shadow_state = "shadow-shelf-fancy"

// ################ METAL SHELVING ######################

/obj/structure/wall_rack/shelf/metal
	name = "mesh shelf"

	icon_state = "shelf-mesh"
	shadow_state = "shadow-shelf-mesh"

	resistance_flags = FIRE_PROOF
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)
