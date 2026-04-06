/obj/item/pot_shard

	name = "ceramic shard"
	desc = "The potter's fractured vision. Maybe some glue could fix it?"


	base_icon_state = "ceramic_shard"

	force = 5
	throwforce = 3

	sharpness = SHARP_EDGED

	resistance_flags = FIRE_PROOF | ACID_PROOF

	drop_sound = SFX_FOOD_PLATE_DROP
	pickup_sound = SFX_FOOD_PLATE_PICKUP

	//How many sprite icon variants do we have
	var/shard_variants = 6

/obj/item/pot_shard/Initialize(mapload)
	. = ..()
	icon_state = "[base_icon_state]_[rand(1, shard_variants)]"

/obj/item/pot_shard/terracotta
	name = "terracotta shard"
	icon_state = "terracotta_shard_1"
	base_icon_state = "terracotta_shard"
	shard_variants = 9

/obj/effect/decal/cleanable/soil_spill
	name = "soil"
	icon= 'icons/obj/fluff/flora/pot_stuff.dmi'
	icon_state = "soil_spill_1"
	base_icon_state = "soil_spill"

/obj/effect/decal/cleanable/soil_spill/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	icon_state = "[base_icon_state]_[rand(1, 4)]"

