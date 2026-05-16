#define POT_KNOCKDOWN_THRESHOLD 5 //Minimum hammer force threshhold to knockdown.
#define POT_THROW_SPEED_MOD 0.25 // Multiplied with throwing speed to scale the impact effect of thrown / launched pots.

// TO DO: Rewrite to use integrity

/obj/item/dedeplants
	name = "potted plant"
	desc = "Containerized photosynthetic lifeform."

	icon = 'icons/obj/fluff/flora/dedeplants.dmi'
	icon_state = "plant"

	w_class = WEIGHT_CLASS_NORMAL

	force = 5
	sharpness = NONE
	throwforce = 5
	throw_range = 6

	drop_sound = SFX_POTTED_PLANT_DROP
	pickup_sound = SFX_POTTED_PLANT_PICKUP

	custom_materials = list(/datum/material/biomass = SHEET_MATERIAL_AMOUNT, /datum/material/sand = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT)
	/// Any trash or remenants to leave behind when smashed.
	var/list/pot_remnants = list(/obj/effect/decal/cleanable/soil_spill)
	/// If we should break the pot on impact or if it is some kind of indestructible super-pot.
	var/break_on_impact = TRUE
	/// Alternative sharpness for the bonus head smash damage. Like SHARP_EDGED from the ceramic fragments, or SHARP_POINTY cactus spines.
	var/pot_hammer_sharpness = NONE
	/// Wound bonus for the pot hammer damage.
	var/pot_hammer_wound_bonus = 0
	/// Sound for when the pot is smashed
	var/smash_sound = 'sound/items/weapons/genhit2.ogg'

/obj/item/dedeplants/afterattack(atom/target, mob/user, list/modifiers)
	. = ..()
	pot_hammer(target, user.zone_selected)

/obj/item/dedeplants/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	pot_hammer(hit_atom, throwingdatum.target_zone, throwingdatum.speed * POT_THROW_SPEED_MOD)

/// Called when the potted plant violently impacts something, potentially shattering the pot and smushing the plant. returns TRUE if the pot is smashed to pieces. Should probably be split into two procs.
/obj/item/dedeplants/proc/pot_hammer(atom/colliding_party, var/hit_zone, var/intensity_mod = 1)
	if(break_on_impact)
		if(pot_remnants?.len)
			// Spawn soil, shard, plant smudges etc
			for(var/remnant_type in pot_remnants)
				var/atom/remenant = new remnant_type(drop_location())
				remenant.pixel_x = rand(-4, 4)
				remenant.pixel_y = rand(-3, 3)

		// Here we handle head smashing behaviour for living hammer victims.
		if(isliving(colliding_party) && hit_zone == BODY_ZONE_HEAD && !QDELETED(colliding_party))
			var/mob/living/pot_victim = colliding_party
			// Bonus effects are reduced by armour and also halfed by head protection from helmets.
			var/head_protection_mod = (1 - pot_victim.getarmor(BODY_ZONE_HEAD, MELEE) / 100) * HAS_TRAIT(pot_victim, TRAIT_HEAD_INJURY_BLOCKED) ? 0.5 : 1
			// Both knockdown(in deciseconds) and bonus damage are determined by item force * head_protection_mod * intensity_mod.
			// intensity is there to scale down the effects of thrown pots.
			var/hammer_force = force * head_protection_mod * intensity_mod
			// If hammer force is below the threshhold, only daze.
			pot_victim.Knockdown((hammer_force > POT_KNOCKDOWN_THRESHOLD ? hammer_force : 0) DECISECONDS, hammer_force * 2 DECISECONDS)
			pot_victim.apply_damage(damage = hammer_force, damagetype = BRUTE, def_zone = BODY_ZONE_HEAD, wound_bonus = pot_hammer_wound_bonus, sharpness = pot_hammer_sharpness, attacking_item = src)

		playsound(colliding_party, smash_sound, 100)
		qdel(src)
		return TRUE
	else
		return FALSE


/obj/item/dedeplants/ceramic
	force = 10
	throwforce = 15

	custom_materials = list(/datum/material/biomass = SHEET_MATERIAL_AMOUNT, /datum/material/sand = SHEET_MATERIAL_AMOUNT)

	pot_remnants = list(
		/obj/effect/decal/cleanable/soil_spill,
		/obj/item/pot_shard,
		/obj/item/pot_shard,
		/obj/item/pot_shard,
	)

	pot_hammer_sharpness = SHARP_EDGED
	pot_hammer_wound_bonus = 10

	smash_sound = 'sound/items/ceramic_break.ogg'

/obj/item/dedeplants/ceramic/grind_results()
	return list(/datum/reagent/silicon = 10)


//------------ HOUSE PLANTS ----------------------


/obj/item/dedeplants/pepper
	name = "hot pepper plant"
	desc = "Capsicum annuum. Spicy!"

	icon_state = "pepper"
	SET_BASE_VISUAL_PIXEL(0, 8)

	pot_remnants = list(/obj/effect/decal/cleanable/soil_spill, /obj/item/food/grown/chili)

/obj/item/dedeplants/pepper/grind_results()
	return list(/datum/reagent/silicon = 10, /datum/reagent/consumable/capsaicin = 10)

/obj/item/dedeplants/seedling
	name = "seedling"
	desc = "I wonder what it will grow up to be?"

	icon_state = "seedling"

	force = 3
	throwforce = 3

/obj/item/dedeplants/myrmeco
	name = "ant-house plant"
	desc = "Myrmecodia beccarii: This plant is a vertiable fortress, fiercely defended by its little six legged soldiers."

	icon_state = "myrmeco"
	SET_BASE_VISUAL_PIXEL(0, 5)

	force = 10
	throwforce = 15

	pot_hammer_sharpness = SHARP_POINTY
	pot_hammer_wound_bonus = 10

	pot_remnants = list(/obj/effect/decal/cleanable/soil_spill, /obj/effect/decal/cleanable/ants)

/obj/item/dedeplants/myrmeco/grind_results()
		return list(/datum/reagent/silicon = 10, /datum/reagent/ants = 20)

/obj/item/dedeplants/myrmeco/pot_hammer(atom/colliding_party, var/hit_zone) //ants suck, remember to buff ants.
	if(..() && iscarbon(colliding_party) && !QDELETED(colliding_party))
		var/mob/living/carbon/ant_house_victim = colliding_party
		ant_house_victim.apply_status_effect(/datum/status_effect/ants, 20)

/obj/item/dedeplants/arabidopsis
	name = "arabidopsis"
	desc = "Arabidopsis thaliana: The most well studied plant in the universe! Other than that fact it is quite unremarkable..."

	icon_state = "arabidopsis"
	SET_BASE_VISUAL_PIXEL(0, 4)

//---- CERAMIC
/obj/item/dedeplants/ceramic/monstera
	name = "monstera"
	desc = "Monstera deliciosa. And beautiful specimen at that!"

	icon_state = "monstera"
	SET_BASE_VISUAL_PIXEL(0, 10)

	force = 15
	throwforce = 20
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY

/obj/item/dedeplants/ceramic/snake_plant
	name = "snake plant"
	desc = "Dracaena trifasciata. How fitting!"

	icon_state = "snake"
	SET_BASE_VISUAL_PIXEL(0, 6)

/obj/item/dedeplants/ceramic/jade_plant
	name = "jade plant"
	desc = "Crassula ovata: A nice little succulent with glassy fat leaves. Also known as the money plant.\n\nYou sometimes dream about owning a literal money plant, however, once you start thinking about the inflationary implications of such a senario, reality comes quickly crashing back in."

	icon_state = "jade"
	SET_BASE_VISUAL_PIXEL(0, 4)

/obj/item/dedeplants/ceramic/sus_orchid
	name = "syndicate orchid"
	desc = "Astraenopsis suspectus: The first houseplant product with genetics expertly engineered for a life in space."

	icon_state = "sus_orchid"
	SET_BASE_VISUAL_PIXEL(0, 6)

/obj/item/dedeplants/ceramic/bonsai
	name = "bonsai"
	desc = "A perculiar tree, it has the appearance on an ancient bethemoth yet it remains the size of a sapling. Could this be the product of the ancient bonsai technique as practiced in the orient?"

	icon_state = "bonsai-cypress"
	SET_BASE_VISUAL_PIXEL(0, 4)


// --------------- CACTI --------------------------

/obj/item/dedeplants/ceramic/cactus
	name = "cactus"
	desc = "A spiny succulent. Well prepared for neglect and mishandling!"

	icon_state = "cactus"

	force = 5
	throwforce = 10
	pot_hammer_sharpness = SHARP_POINTY
	pot_hammer_wound_bonus = 10

	pot_remnants = list(
	/obj/effect/decal/cleanable/soil_spill,
	/obj/item/pot_shard/terracotta,
	/obj/item/pot_shard/terracotta,
	/obj/item/pot_shard/terracotta,
	)

/obj/item/dedeplants/ceramic/cactus/topfluff
	name = "fluffy cactus"
	desc = "A spiny succulent. This one has a nice head of white hair."

	icon_state = "cactus_topfluff"

	force = 8
	throwforce = 12
	pot_hammer_sharpness = SHARP_POINTY
	pot_hammer_wound_bonus = 10

/obj/item/dedeplants/ceramic/cactus/flowering
	desc = "flowering cactus"
	desc = "Lophophora williamsii: A small spineless cactus known in its native region as 'peyote', where it is sometimes consumed to induce a narcotic effect."

	icon_state = "cactus_flower"

	pot_hammer_sharpness = SHARP_EDGED
	pot_hammer_wound_bonus = 0

/obj/item/dedeplants/ceramic/cactus/flowering/grind_results()
	return list(/datum/reagent/silicon = 10, /datum/reagent/drug/mushroomhallucinogen = 5)

/obj/item/dedeplants/ceramic/cactus/tiny
	name = "tiny cactus"
	desc = "A tiny succulent. Ill prepared for neglect and mishandling!"

	icon_state = "cactus_tiny"

	force = 3
	throwforce = 6
	pot_hammer_sharpness = SHARP_POINTY
	pot_hammer_wound_bonus = 5

/obj/item/dedeplants/ceramic/cactus/opuntia
	name = "prickly pear"
	desc = "Opuntia ficus-indica: A cactus capable of producing delicious figs, imagine that!"

	icon_state = "cactus_opuntia"

	force = 8
	throwforce = 12
	pot_hammer_sharpness = SHARP_EDGED
	pot_hammer_wound_bonus = 5
	SET_BASE_VISUAL_PIXEL(0, 6)


#undef POT_KNOCKDOWN_THRESHOLD
#undef POT_THROW_SPEED_MOD
