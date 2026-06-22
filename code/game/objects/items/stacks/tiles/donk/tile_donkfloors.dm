// METAL TILES

/obj/item/stack/tile/steel
	name = "steel tiles"
	singular_name = "steel tile"
	desc = "The tiles still look nice and shiny after all these years."
	icon = 'icons/obj/donkstacks/donktiles.dmi'
	icon_state = "steel_tile"
	inhand_icon_state = "tile"

	force = 6
	throwforce = 10
	armor_type = /datum/armor/tile_iron

	obj_flags = CONDUCTS_ELECTRICITY
	resistance_flags = FIRE_PROOF

	matter_amount = 1
	mats_per_unit = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*0.25)

	turf_type = /turf/open/floor/steel_tile
	merge_type = /obj/item/stack/tile/steel


/obj/item/stack/tile/plastitanium
	name = "plastitanium tiles"
	singular_name = "plastitanium tile"
	desc = "These tiles feel cold and impersonal..."

	icon = 'icons/obj/donkstacks/donktiles.dmi'
	icon_state = "plastitanium_tile"
	inhand_icon_state = "tile"

	obj_flags = CONDUCTS_ELECTRICITY
	resistance_flags = FIRE_PROOF | ACID_PROOF

	mats_per_unit = list(/datum/material/alloy/plastitanium=SHEET_MATERIAL_AMOUNT*0.25)

	turf_type = /turf/open/floor/plastitanium_tile
	merge_type = /obj/item/stack/tile/plastitanium

/obj/item/stack/tile/plastitanium/scale
	name = "plastitanium scale tiles"
	singular_name = "plastitanium scale tile"
	desc = "These tilessssss.. feel cold and impersonal..."

	icon_state = "plastitanium_scale"

	turf_type = /turf/open/floor/plastitanium_tile/scale

// CERAMIC & STONE TILES

/obj/item/stack/tile/cool
	name = "cool tiles"
	singular_name = "cool tile"
	icon = 'icons/obj/donkstacks/donktiles.dmi'
	icon_state = "cool_tile"
	inhand_icon_state = "tile"

	resistance_flags = FIRE_PROOF

	mats_per_unit = list(/datum/material/glass=SHEET_MATERIAL_AMOUNT*0.25)

	turf_type = /turf/open/floor/cool_tile
	merge_type = /obj/item/stack/tile/cool

/obj/item/stack/tile/terracotta
	name = "terracotta tiles"
	singular_name = "terracotta tile"
	icon = 'icons/obj/donkstacks/donktiles.dmi'
	icon_state = "terracotta_tile"
	inhand_icon_state = "tile"

	resistance_flags = FIRE_PROOF

	mats_per_unit = list(/datum/material/glass=SHEET_MATERIAL_AMOUNT*0.25)

	turf_type = /turf/open/floor/terracotta
	merge_type = /obj/item/stack/tile/terracotta

/obj/item/stack/tile/marble
	name = "marble tiles"
	singular_name = "marble tile"
	icon = 'icons/obj/donkstacks/donktiles.dmi'
	icon_state = "marble_tile"
	inhand_icon_state = "tile"

	resistance_flags = FIRE_PROOF

	mats_per_unit = list(/datum/material/glass=SHEET_MATERIAL_AMOUNT*0.25)

	turf_type = /turf/open/floor/marble
	merge_type = /obj/item/stack/tile/marble

/obj/item/stack/tile/brick
	name = "bricks"
	singular_name = "brick"
	icon = 'icons/obj/donkstacks/donktiles.dmi'
	icon_state = "bricks"
	inhand_icon_state = "tile" //change to a proper brick later
	novariants = FALSE


	resistance_flags = FIRE_PROOF
	full_w_class = WEIGHT_CLASS_HUGE


	mats_per_unit = list(/datum/material/glass=SHEET_MATERIAL_AMOUNT*0.25)

	turf_type = /turf/open/floor/brick
	merge_type = /obj/item/stack/tile/brick

// ------------------------ CARPET TILES ------------------------

/obj/item/stack/tile/carpet/borderless
	name = "barred carpet roll"
	singular_name = "barred carpet roll"
	desc = "A roll of tufted carpet."

	icon = 'icons/obj/donkstacks/carpet_rolls.dmi'
	icon_state = "carpet_roll_zigzag"
	// Add inhand icons later

	turf_type = /turf/open/floor/carpet/borderless
	merge_type = /obj/item/stack/tile/carpet/borderless

/obj/item/stack/tile/carpet/borderless/zigzag
	name = "zigzag carpet roll"
	singular_name = "zigzag carpet roll"

	icon_state = "carpet_roll_zigzag"

	turf_type = /turf/open/floor/carpet/borderless/zigzag
	merge_type = /obj/item/stack/tile/carpet/borderless/zigzag

/obj/item/stack/tile/carpet/borderless/cream
	name = "cream carpet roll"
	singular_name = "cream carpet roll"

	icon_state = "carpet_roll_cream"

	turf_type = /turf/open/floor/carpet/borderless/cream
	merge_type = /obj/item/stack/tile/carpet/borderless/cream

/obj/item/stack/tile/carpet/borderless/grey
	name = "grey carpet roll"
	singular_name = "grey carpet roll"

	icon_state = "carpet_roll_grey"

	turf_type = /turf/open/floor/carpet/borderless/grey
	merge_type = /obj/item/stack/tile/carpet/borderless/grey

/obj/item/stack/tile/carpet/borderless/teal
	name = "teal carpet roll"
	singular_name = "teal carpet roll"
	icon_state = "carpet_roll_teal"
	turf_type = /turf/open/floor/carpet/borderless/teal
	merge_type = /obj/item/stack/tile/carpet/borderless/teal

/obj/item/stack/tile/carpet/borderless/orange
	name = "orange carpet roll"
	singular_name = "orange carpet roll"
	icon_state = "carpet_roll_orange"
	turf_type = /turf/open/floor/carpet/borderless/orange
	merge_type = /obj/item/stack/tile/carpet/borderless/orange

/obj/item/stack/tile/carpet/borderless/avocado
	name = "avocado carpet roll"
	singular_name = "avocado carpet roll"
	icon_state = "carpet_roll_avocado"
	turf_type = /turf/open/floor/carpet/borderless/avocado
	merge_type = /obj/item/stack/tile/carpet/borderless/avocado

/obj/item/stack/tile/carpet/borderless/mustard
	name = "mustard carpet roll"
	singular_name = "mustard carpet roll"
	icon_state = "carpet_roll_mustard"
	turf_type = /turf/open/floor/carpet/borderless/mustard
	merge_type = /obj/item/stack/tile/carpet/borderless/mustard

/obj/item/stack/tile/carpet/borderless/red
	name = "red carpet roll"
	singular_name = "red carpet roll"
	icon_state = "carpet_roll_red"
	turf_type = /turf/open/floor/carpet/borderless/red
	merge_type = /obj/item/stack/tile/carpet/borderless/red

/obj/item/stack/tile/carpet/sus
	name = "really suspicious carpet roll"
	singular_name = "really suspicious carpet roll"
	desc = "I should unroll it and see what is going on with this thing.."

	icon = 'icons/obj/donkstacks/carpet_rolls.dmi'
	icon_state = "carpet_roll_sus"
	turf_type = /turf/open/floor/carpet/sus
	merge_type = /obj/item/stack/tile/carpet/sus
