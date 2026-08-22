/obj/structure/space_ship
	name = "gorlex blood red assault pod"
	desc = "A compact syndicate assault ship, outfitted with the latest kinetic projectile weaponry."

	icon = 'icons/obj/fluff/syndicate/syndie_ships.dmi'
	icon_state = "gorlex_ship-blood_red"

	appearance_flags = LONG_GLIDE

	bound_width = 96
	bound_height = 96

	density = TRUE
	anchored = TRUE

	custom_materials = list(
	/datum/material/alloy/plastitanium = 20 * SHEET_MATERIAL_AMOUNT,
	/datum/material/lead = 4 * SHEET_MATERIAL_AMOUNT,
	/datum/material/alloy/plastitaniumglass = 2 * SHEET_MATERIAL_AMOUNT,
	)

	smash_drops = list(
		/obj/item/stack/sheet/mineral/plastitanium,
		/obj/item/stack/sheet/mineral/plastitanium,
		/obj/item/stack/sheet/mineral/plastitanium,
		/obj/item/shard/plastitanium,
		/obj/item/lead_pipe,
	)

	SET_BASE_PIXEL(-32,-32)

/obj/structure/space_ship/elite
	name = "gorlex elite pod"
	icon_state = "gorlex_ship-elite"

/obj/structure/space_ship/compact
	name = "gorlex midnight pod"
	icon_state = "gorlex_ship-midnight"
