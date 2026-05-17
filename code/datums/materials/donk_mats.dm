/datum/material/rock/marble
	name = "marble"
	desc = "Only the best is good enough."

	color = "#f8f7f4"
	texture_layer_icon_state = "marble"
	mat_flags = MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_RIGID
	mat_properties = list(
		MATERIAL_DENSITY = 3,
		MATERIAL_HARDNESS = 4,
		MATERIAL_FLEXIBILITY = 0,
		MATERIAL_REFLECTIVITY = 6,
		MATERIAL_ELECTRICAL = 0,
		MATERIAL_THERMAL = 1,
		MATERIAL_CHEMICAL = 0,
		MATERIAL_BEAUTY = 0.8,
	)
	sheet_type = /obj/item/stack/sheet/marble
	value_per_unit = 10 * SPACE_CASH / SHEET_MATERIAL_AMOUNT
	item_sound_override = SFX_POTTED_PLANT_DROP
	turf_sound_override = FOOTSTEP_CONCRETE
	mat_rust_resistance = RUST_RESISTANCE_BASIC

/datum/material/concrete
	name = "concrete"
	desc = "The pourable stone that built rome."

	color = "#959392"
	texture_layer_icon_state = "concrete"

	mat_flags = MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_RIGID
	mat_properties = list(
		MATERIAL_DENSITY = 6,
		MATERIAL_HARDNESS = 7,
		MATERIAL_FLEXIBILITY = 0,
		MATERIAL_REFLECTIVITY = 3,
		MATERIAL_ELECTRICAL = 0,
		MATERIAL_THERMAL = 1,
		MATERIAL_CHEMICAL = 0,
	)
	value_per_unit = 0.1 * SPACE_CASH / SHEET_MATERIAL_AMOUNT
	item_sound_override = SFX_POTTED_PLANT_DROP
	turf_sound_override = FOOTSTEP_CONCRETE
	mat_rust_resistance = RUST_RESISTANCE_REINFORCED

/datum/material/concrete/on_main_applied(atom/source, mat_amount, multiplier)
	. = ..()
	if(!isobj(source) || !(source.material_flags & MATERIAL_AFFECT_STATISTICS))
		return
	var/obj/concrete = source
	concrete.resistance_flags |= FIRE_PROOF | FREEZE_PROOF

/datum/material/lead
	name = "lead"
	desc = "The heavy metal that fell rome. You don't have to worry about working with this, the toxicity has been greatly exaggerated by laser gun manufacturers."

	color = "#959ebd"

	mat_flags = MATERIAL_BASIC_RECIPES | MATERIAL_CLASS_RIGID
	mat_properties = list(
		MATERIAL_DENSITY = 8,
		MATERIAL_HARDNESS = 2,
		MATERIAL_FLEXIBILITY = 6,
		MATERIAL_REFLECTIVITY = 2,
		MATERIAL_ELECTRICAL = 6,
		MATERIAL_THERMAL = 4,
		MATERIAL_CHEMICAL = 4,
	)
	value_per_unit = 2 * SPACE_CASH / SHEET_MATERIAL_AMOUNT
	mat_rust_resistance = RUST_RESISTANCE_REINFORCED
