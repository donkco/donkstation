/obj/item/hatchet/tomahawk
	name = "tomahawk"
	desc = "You tactitically assertain this to be a shiny metal axe. It is designed for maximum warfighting lethality."

	icon = 'icons/obj/weapons/donk_weapons.dmi'
	icon_state = "tomahawk"
	icon_angle = -23
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi' // TODO change this
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'

	force = 20
	throwforce = 20
	throw_range = 7
	embed_type = /datum/embedding/tomahawk
	custom_materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3)
	attack_verb_continuous = list("chops", "tears", "lacerates", "cuts", "savages")
	attack_verb_simple = list("chop", "tear", "lacerate", "cut", "savage")

/datum/embedding/tomahawk
	pain_mult = 6
	embed_chance = 65
	fall_chance = 10
