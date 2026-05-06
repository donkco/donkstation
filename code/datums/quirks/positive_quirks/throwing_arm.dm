/datum/quirk/throwingarm
	name = "Promising Pitcher"
	quirk_category = QUIRK_CATEGORY_POSITIVE
	desc = "Your arms have a lot of heft to them! Objects that you throw just always seem to fly farther than everyone else's, and you never miss a toss."
	icon = FA_ICON_BASEBALL
	value = 7
	mob_trait = TRAIT_THROWINGARM
	gain_text = span_notice("Your arms are full of energy!")
	lose_text = span_danger("Your arms ache a bit.")
	medical_record_text = "Patient displays mastery over throwing objects."
	contract_flavor_text = "Subject exhibits exceptional throwing mechanics and above-average arm strength. \
		Projectiles released by this individual consistently achieve greater range and accuracy than baseline. \
		No formal sports history on file, though shoulder musculature suggests years of practice."
	mail_goodies = list(/obj/item/toy/beach_ball/baseball, /obj/item/toy/basketball, /obj/item/toy/dodgeball)
