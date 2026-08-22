/obj/structure/rock
	name = "rock"
	desc = "A piece of wild untamed stone."
	icon = 'icons/obj/fluff/biome_snow/snowy_rocks.dmi'
	icon_state = "rock"

	density = TRUE
	resistance_flags = FIRE_PROOF

/obj/structure/rock/snow
	desc = "A stone sleeping under a blanket of snow."
	icon_state  = "rock-snow-1"
	base_icon_state = "rock-snow"
	density = FALSE

/obj/structure/rock/snow/random

/obj/structure/rock/snow/random/Initialize(mapload)
	. = ..()
	icon_state = "[base_icon_state]-[rand(1,5)]"

/obj/structure/rock/snow/collum_piece
	icon_state  = "pillar_fragment-snow"

	density = TRUE

/obj/structure/rock/snow/snowhenge
	name = "snowy henge"
	desc = "A peculiar rock formation. You wonder if it once had a purpose."
	icon_state  = "snow_henge"

	density = TRUE

/obj/structure/rock/snow/stone_circle
	name = "stone circle"
	desc = "A little circle of rocks. Maybe they are having a meeting?"
	icon_state  = "snow_rock-circle"

	density =  FALSE

/obj/structure/rock/snow/slab
	name = "stone slab"
	desc = "A big stone, that somehow looks out of place."
	icon_state  = "snow_slab"

	density = TRUE

/obj/structure/rock/snow/grim_pillar
	name = "grim pillar"
	desc = "A stone pillar holding some scattered bones. A strange burial practice or perhaos an offering to dark Gods?"
	icon_state = "rock_pillar-bones"
	density = TRUE

/obj/structure/rock/snow/bound_pillar
	name = "cloth-bound pillar"
	desc = "A pillar made of stones with a length of cloth wrapped around it. The cloth flutters in the cold wind."
	icon_state = "rock_pillar-cloth_bound"

/obj/structure/rock/snow/beast_skull
	name = "frozen bones"
	desc = "The remains of some kind of creature. Maybe it couldn't handle the cold."
	icon_state  = "skull-beast"

	density = FALSE

// ------------ STONE HEADS ---------------------

/obj/structure/rock/snow/stone_head
	name = "stone head"
	desc = "This rock almost looks like a person! That's odd...."
	icon_state  = "stone_head-1"

	density = TRUE

/obj/structure/rock/snow/stone_head/snowiest
	icon_state  = "stone_head-2"

/obj/structure/rock/snow/stone_head/snow_nose
	icon_state  = "stone_head-3"

/obj/structure/rock/snow/stone_head/fallen
	name = "fallen stone head"
	desc = "This head has fallen over. Perhaps the fate of whatever ancient people created him, was too much to bear."
	icon_state  = "stone_head-fallen"

/obj/structure/rock/snow/stone_head/chief
	name = "stone head chief"
	desc = "A great stone, probably erected in honor of a great man long forgotten. You look upon the work, and despair."
	icon = 'icons/obj/fluff/biome_snow/snow_large_64x64.dmi'
	icon_state  = "stone_head-chief"

	density = TRUE
	SET_BASE_PIXEL(-16,0)

/obj/structure/rock/snow/stone_head/chief/nest
	icon_state  = "stone_head-chief-nest"

