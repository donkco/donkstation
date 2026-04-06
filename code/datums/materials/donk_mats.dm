/datum/material/marble
	name = "marble"
	desc = "Only the best is good enough."
	color = "#f8f7f4"
	categories = list(
		MAT_CATEGORY_RIGID = TRUE,
		MAT_CATEGORY_BASE_RECIPES = TRUE,
		MAT_CATEGORY_ITEM_MATERIAL = TRUE,
		MAT_CATEGORY_ITEM_MATERIAL_COMPLEMENTARY = TRUE,
		)
	sheet_type = /obj/item/stack/sheet/marble
	value_per_unit = 10 * SPACE_CASH / SHEET_MATERIAL_AMOUNT
	armor_modifiers = list(MELEE = 0.5, BULLET = 0.5, LASER = 1.25, ENERGY = 0.5, BOMB = 0.5, BIO = 0.25, FIRE = 1.5, ACID = 1.5)
	beauty_modifier = 1.3
	turf_sound_override = FOOTSTEP_WOOD
	texture_layer_icon_state = "brick"
	mat_rust_resistance = RUST_RESISTANCE_BASIC
