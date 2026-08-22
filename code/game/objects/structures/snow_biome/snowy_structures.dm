// ------------ WOODEN SNOW STRUCTURES ---------------

/obj/structure/fluff/snow/wooden
	name = "signpost"
	desc = "An old signpost, it so weathered you cant make out any legible writing."

	icon = 'icons/obj/fluff/biome_snow/snow_structures.dmi'
	icon_state = "crossed_sign"

	density = FALSE
	custom_materials = list(/datum/material/wood = 6 * SHEET_MATERIAL_AMOUNT)

	smash_drops = list(
		/obj/item/stack/sheet/mineral/wood,
		/obj/item/stack/sheet/mineral/wood,
	)


/obj/structure/fluff/snow/wooden/chicken_coop
	name = "chicken coop"
	desc = "An old dilapidated chicken coop. You hope the birds are somewhere warmer now."

	icon_state = "chicken_coop-1"

	density = TRUE
	broken = TRUE

	smash_drops = list(
		/obj/item/stack/sheet/mineral/wood,
		/obj/item/stack/sheet/mineral/wood,
		/obj/item/stack/sheet/mineral/wood,
		/obj/item/food/egg/organic,
	)

/obj/structure/fluff/snow/wooden/chicken_coop/alt
	icon_state = "chicken_coop-2"

/obj/structure/fluff/snow/wooden/chicken_coop/alt_two
	icon_state = "chicken_coop-3"

/obj/structure/fluff/snow/wooden/outhouse
	name = "outhouse"
	desc = "Finally, I was thinking this planet might not have them."
	icon_state = "outhouse"

	density = TRUE

	smash_drops = list(
		/obj/item/stack/sheet/mineral/wood,
		/obj/item/stack/sheet/mineral/wood,
	)

/obj/structure/fluff/snow/wooden/gruesome_pole
	name = "gruesome pole"
	desc = "A warning! Or a triumph?"
	icon_state = "gore_pole"

	density = FALSE
	custom_materials = list(/datum/material/wood = 1 * SHEET_MATERIAL_AMOUNT, /datum/material/bone = SHEET_MATERIAL_AMOUNT)
	smash_drops = list(/obj/item/stack/sheet/mineral/wood, /obj/item/clothing/head/helmet/skull, /obj/item/organ/heart/freedom)

// ------------ TECHY SNOW STRUCTURES ---------------

/obj/structure/fluff/snow/tech
	name = "geothermal substation"
	desc = "I guess this is how they heat the place. I guess it is cheaper than burning plasma."

	icon = 'icons/obj/fluff/biome_snow/snow_structures.dmi'
	icon_state = "snowy_substation"

	density = TRUE
	custom_materials = list(/datum/material/iron = 5 * SHEET_MATERIAL_AMOUNT)
	smash_drops = list(
		/obj/item/stack/sheet/iron,
		/obj/item/stack/sheet/iron,
		/obj/item/stack/sheet/iron,
		/obj/item/stack/sheet/iron,
	)

/obj/structure/fluff/snow/tech/hose
	name = "geothermal hose"
	desc = "I guess this is how they pipe the heat around."
	icon_state = "snowy_tube"

	density = FALSE
	custom_materials = list(/datum/material/plastic = 5 * SHEET_MATERIAL_AMOUNT)

	smash_drops = list(
		/obj/item/stack/sheet/plastic,
		/obj/item/stack/sheet/plastic,
		/obj/item/stack/sheet/plastic,
	)

/obj/structure/fluff/snow/tech/hose/open_end
	icon_state = "snowy_tube-open_end"

/obj/structure/fluff/snow/tech/hose/closed_end
	icon_state = "snowy_tube-closed_end"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/fluff/snow/tech, 0)
