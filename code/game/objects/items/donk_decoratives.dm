/obj/item/vase

	name = "vase"
	desc = "The potter's vision, fully realized by his fingers."

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "vase-mustard"

	force = 7
	throwforce = 10

	obj_flags = CAN_BE_HIT
	max_integrity = 6
	damage_deflection = 6 //to simulate a hard and brittle material, it resists light blows but shatters suddenly.
	resistance_flags = FIRE_PROOF | ACID_PROOF

	drop_sound = SFX_FOOD_PLATE_DROP
	pickup_sound = SFX_FOOD_PLATE_PICKUP


	/// What sound effect to play when the vase is smashed
	var/break_sound
	/// Which types to spawn when the vase is broken (shards etc)
	var/list/vase_remenants = list(
		/obj/item/pot_shard,
		/obj/item/pot_shard,
		)

/obj/item/vase/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(throwingdatum.gentle)
		return
	take_damage(damage_amount = throwingdatum.speed * 5, damage_type = BRUTE, sound_effect = FALSE, damage_flag = MELEE)

/obj/item/vase/atom_deconstruct(disassembled = TRUE)
	if(disassembled)
		return

	if(vase_remenants?.len)
		for(var/atom/remenant in vase_remenants)
			new remenant(loc)
	if(break_sound)
		playsound(src, break_sound, 100, TRUE)


/obj/item/vase/sus
	name = "suspicious vase"
	desc = "The narrow neck looks poised, as if ready to strike..."

	icon_state ="vase-sus"

/obj/item/vase/eggshell

	icon_state = "vase-eggshell"

/obj/item/vase/teal
	icon_state = "vase-teal"

/obj/item/space_prism
	name = "space prism"
	desc = "A little piece of spectral order in a world of confusion."

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "space_prism"

	w_class =  WEIGHT_CLASS_SMALL

	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT)

/obj/item/space_scanner
	name = "assurance scanner"
	desc = "A device for ensuring correctness by detecting the tell-tale sigs of things not being in order."

	force = 6
	throwforce = 6

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "space_scanner"

	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT, /datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/statuette
	name = "excellence in management award"

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "statuette-award-silver"

	force = 7
	throw_force = 7

	custom_materials = list(/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/statuette/gold
	name = "syncademy award for outstanding B2B SaaS sales"
	icon_state = "statuette-award-gold"

	custom_materials = list(/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/statuette/goose
	name = "gracile fowl statuette"
	icon_state = "statuette-goose"

	custom_materials = list(/datum/material/marble = SHEET_MATERIAL_AMOUNT)

/obj/item/typewriter
	name = "typewriter"
	desc = "A manual typewriter, the backbone of any modern corporation."
	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "typewriter"

	force = 10
	throw_force = 10
	throw_range = 5
	throw_speed = 1

	w_class = WEIGHT_CLASS_BULKY

	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT, /datum/material/plastic = SHEET_MATERIAL_AMOUNT)

/obj/item/pen_holder
	name = "pen holder"
	desc = "A little dock for your fountain pen."

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "pen_holder"

	w_class = WEIGHT_CLASS_SMALL

	/// The pen we are holding.
	var/obj/item/docked_pen
	/// If we want to spawn without a pen for some reason set to TRUE. (environmental storytelling)
	var/penless = FALSE

/obj/item/pen_holder/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/drag_pickup)
	if(penless)
		return
	docked_pen = new /obj/item/pen/fountain/black(src)

/obj/item/pen_holder/attack_hand(mob/living/user, list/modifiers)
	if(!docked_pen)
		return
	if(!iscarbon(user) || !user.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
		return

	user.put_in_hands(docked_pen)

	if(docked_pen?.loc != src)
		docked_pen = null

/obj/item/pen_holder/attacked_by(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!istype(attacking_item, /obj/item/pen))
		return

	user.transferItemToLoc(attacking_item, src)
	docked_pen = attacking_item

/obj/item/pen/fountain/black

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "fountain-black"

/obj/item/title_plaque
	name = "station executive"
	desc = "Small plaque displaying a big title."

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "title_plaque"

	obj_flags = UNIQUE_RENAME

	custom_materials = list(/datum/material/bronze = HALF_SHEET_MATERIAL_AMOUNT)
