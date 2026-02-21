/turf/closed/wall/calabash
	name = "calabash wall"
	desc = "The wall of the future. The sloped, tightly fitted panels can make some configurations look somewhat gourd-like, hence the name."
	sheet_type = /obj/item/stack/sheet/iron
	hardness = 40
	sheet_amount = 2
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CALABASH_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_CALABASH_WALLS
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2)
	rust_resistance = RUST_RESISTANCE_BASIC

/turf/closed/wall/calabash/med
	desc = "The wall of the future. This section has a soothing, clinical appearance."

	icon = 'icons/turf/walls/donkwalls/calabash_med_wall.dmi'
	icon_state = "calabash_med_wall-0"
	base_icon_state = "calabash_med_wall"

/turf/closed/wall/calabash/sus
	desc = "The wall of the future. This one looks a bit suspicious."

	icon = 'icons/turf/walls/donkwalls/calabash_sus_wall.dmi'
	icon_state = "calabash_sus_wall-0"
	base_icon_state = "calabash_sus_wall"

/turf/closed/wall/tile
	name = "tile wall"
	desc = "A tiles hung on a metal grid frame. It does not seem very sturdy, but it is at least easy to build and maintain."

	icon = 'icons/turf/walls/donkwalls/tile_wall.dmi'
	icon_state = "tile_wall-0"
	base_icon_state = "tile_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TILE_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_TILE_WALLS

	sheet_type = /obj/item/stack/tile/cool
	hardness = 80
	sheet_amount = 1
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1)
	rust_resistance = RUST_RESISTANCE_BASIC

/turf/closed/wall/tile/decaying
	name = "decaying tile wall"
	desc = "These tiles have seen better days. Is that mold?"
	icon = 'icons/turf/walls/donkwalls/decaying_tile_wall.dmi'
	icon_state = "decaying_tile_wall-0"
	base_icon_state = "decaying_tile_wall"


/turf/closed/wall/plywood
	name = "plywood wall"
	desc = "Engineered wood! Humanities cure for the flawed anisotropicy of nature."
	icon = 'icons/turf/walls/donkwalls/plywood_wall.dmi'
	icon_state = "plywood_wall-0"
	base_icon_state = "plywood_wall"
	sheet_type = /obj/item/stack/sheet/mineral/wood
	hardness = 70
	sheet_amount = 1
	custom_materials = list(/datum/material/wood =SHEET_MATERIAL_AMOUNT * 2)
	rust_resistance = RUST_RESISTANCE_ORGANIC
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_PLYWOOD_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_PLYWOOD_WALLS
