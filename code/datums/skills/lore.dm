///Abstract parent for lore
/datum/skill/lore
	name = "Lore"
	title = "Scholar"
	desc = "I'm abstract, and if you got me, that means we fucked up"
	modifiers = list(SKILL_SPEED_MODIFIER = list(1, 1, 1, 1, 1, 1, 1))
	is_abstract = TRUE

/datum/skill/lore/New()
	. = ..()
	levelUpMessages[SKILL_LEVEL_BAD] = span_nicegreen("I know a little more about [name] than before. It's a start.")
	levelUpMessages[SKILL_LEVEL_NORMAL] = span_nicegreen("I've reached an average understanding of [name]. Things are starting to make sense.")
	levelUpMessages[SKILL_LEVEL_JOURNEYMAN] = span_nicegreen("I'm getting quite knowledgeable about [name]. I notice things others might miss.")
	levelUpMessages[SKILL_LEVEL_EXPERT] = span_nicegreen("My understanding of [name] runs deep. I can read between the lines now.")
	levelUpMessages[SKILL_LEVEL_MASTER] = span_nicegreen("I consider myself a master [title]. Few could tell me something new about [name].")
	levelUpMessages[SKILL_LEVEL_LEGENDARY] = span_nicegreen("My knowledge of [name] is unparalleled. I am a legendary [title].")
	levelDownMessages[SKILL_LEVEL_BAD] = span_nicegreen("My [name] knowledge is slipping. I'm barely better than a novice again.")
	levelDownMessages[SKILL_LEVEL_NORMAL] = span_nicegreen("My [name] expertise is fading back to average.")
	levelDownMessages[SKILL_LEVEL_JOURNEYMAN] = span_nicegreen("I feel my edge in [name] dulling. I'm no longer particularly knowledgeable.")
	levelDownMessages[SKILL_LEVEL_EXPERT] = span_nicegreen("My deep [name] knowledge is eroding. I'm losing the finer details.")
	levelDownMessages[SKILL_LEVEL_MASTER] = span_nicegreen("I feel my mastery of [name] slipping away.")
	levelDownMessages[SKILL_LEVEL_LEGENDARY] = span_nicegreen("My legendary [name] scholarship is deteriorating. I'll need intensive study to recover.")


/datum/skill/lore/human
	name = "History"
	title = "Historian"
	desc = "Knowledge of human history, politics, and culture across the galaxy."
	is_abstract = FALSE

/datum/skill/lore/mothic
	name = "Mothology"
	title = "Mothologist"
	desc = "Knowledge of Moth culture, traditions, and their ancient history."
	is_abstract = FALSE


/datum/skill/lore/corporate
	name = "Corporate Lore"
	title = "Corporate Analyst"
	desc = "Understanding of megacorporate structures, brands, and internal politics."
	is_abstract = FALSE

/datum/skill/lore/alien
	name = "Alien Lore"
	title = "UFOlogist"
	desc = "The study of illusive alien civilizations, their impact on the ancient world and the present."
	is_abstract =FALSE
