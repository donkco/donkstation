
GLOBAL_LIST_INIT(marble_recipes, list ( \
	new /datum/stack_recipe("marble tile", /obj/item/stack/tile/marble, 1, 4, 20, time = 2 SECONDS, crafting_flags = NONE, category = CAT_TILES), \
))

/obj/item/stack/sheet/marble
	name = "marble slabs"
	desc = "Finest Italian marble."
	singular_name = "marble slab"
	icon = 'icons/obj/donkstacks/donk_sheets.dmi'
	icon_state = "marble_slab"
	inhand_icon_state = null
	throw_speed = 3
	throw_range = 5
	mats_per_unit = list(/datum/material/rock/marble=SHEET_MATERIAL_AMOUNT)
	construction_path_type = "marble"
	merge_type = /obj/item/stack/sheet/marble
	walltype = null
	material_type = /datum/material/rock/marble
	drop_sound = SFX_STONE_DROP
	pickup_sound = SFX_STONE_PICKUP

/obj/item/stack/sheet/marble/get_main_recipes()
	. = ..()
	. += GLOB.marble_recipes

/obj/item/stack/sheet/marble/fifteen
	amount = 15
