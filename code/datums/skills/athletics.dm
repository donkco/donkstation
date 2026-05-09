/datum/skill/athletics
	name = "Athletics"
	title = "Athlete"
	desc = "Twinkle twinkle little star, hit the gym and lift the bar."
	// The skill value modifier effects the max duration that is possible for /datum/status_effect/exercised; The rands modifier determines block probability and crit probability while boxing against boxers
	modifiers = list(
		SKILL_VALUE_MODIFIER = list(
			1 MINUTES,
			1.5 MINUTES,
			2 MINUTES,
			2.5 MINUTES,
			3 MINUTES,
			3.5 MINUTES,
			5 MINUTES
		),
		SKILL_RANDS_MODIFIER = list(
			0,
			5,
			10,
			15,
			20,
			30,
			50
		)
	)

	skill_item_path = /obj/item/clothing/gloves/boxing/golden

/datum/skill/athletics/New()
	. = ..()
	levelUpMessages[SKILL_LEVEL_BAD] = span_nicegreen("I'm still out of shape, but I'm at least getting the hang of [name]! I think I should be able to identify other people who are working to improve their body by sight.")

/datum/skill/athletics/level_gained(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(new_level >= SKILL_LEVEL_BAD && old_level < SKILL_LEVEL_BAD)
		ADD_TRAIT(mind, TRAIT_EXAMINE_FITNESS, SKILL_TRAIT)

/datum/skill/athletics/level_lost(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(old_level >= SKILL_LEVEL_BAD && new_level < SKILL_LEVEL_BAD)
		REMOVE_TRAIT(mind, TRAIT_EXAMINE_FITNESS, SKILL_TRAIT)
