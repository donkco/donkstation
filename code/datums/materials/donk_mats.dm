/datum/material/marble
	name = "marble"
	desc = "Only the best is good enough."

	color = "#f8f7f4"
	texture_layer_icon_state = "marble"

	categories = list(
		MAT_CATEGORY_RIGID = TRUE,
		MAT_CATEGORY_BASE_RECIPES = TRUE,
		MAT_CATEGORY_ITEM_MATERIAL = TRUE,
		MAT_CATEGORY_ITEM_MATERIAL_COMPLEMENTARY = TRUE,
		)
	sheet_type = /obj/item/stack/sheet/marble
	value_per_unit = 10 * SPACE_CASH / SHEET_MATERIAL_AMOUNT
	armor_modifiers = list(MELEE = 0.5, BULLET = 0.5, LASER = 1.15, ENERGY = 0.5, BOMB = 0.5, BIO = 0.25, FIRE = 1.5, ACID = 0.5)
	beauty_modifier = 0.6
	item_sound_override = SFX_POTTED_PLANT_DROP
	turf_sound_override = FOOTSTEP_CONCRETE
	mat_rust_resistance = RUST_RESISTANCE_BASIC

/datum/material/concrete
	name = "concrete"
	desc = "The pourable stone that built rome."

	color = "#959392"
	texture_layer_icon_state = "concrete"

	categories = list(
		MAT_CATEGORY_RIGID = TRUE,
		MAT_CATEGORY_BASE_RECIPES = TRUE,
		MAT_CATEGORY_ITEM_MATERIAL = TRUE,
		MAT_CATEGORY_ITEM_MATERIAL_COMPLEMENTARY = TRUE,
		)
	value_per_unit = 0.1 * SPACE_CASH / SHEET_MATERIAL_AMOUNT
	armor_modifiers = list(MELEE = 1.3, BULLET = 1.5, LASER = 1.15, ENERGY = 0.75, BOMB = 1.5, BIO = 0.25, FIRE = 2, ACID = 0.5)
	added_slowdown = 0.1
	integrity_modifier = 3
	beauty_modifier = -0.03
	item_sound_override = SFX_POTTED_PLANT_DROP
	turf_sound_override = FOOTSTEP_CONCRETE
	mat_rust_resistance = RUST_RESISTANCE_REINFORCED

/datum/material/concrete/on_main_applied(atom/source, mat_amount, multiplier)
	. = ..()
	if(!isobj(source) || !(source.material_flags & MATERIAL_AFFECT_STATISTICS))
		return
	var/obj/concrete = source
	concrete.resistance_flags |= FIRE_PROOF | FREEZE_PROOF
