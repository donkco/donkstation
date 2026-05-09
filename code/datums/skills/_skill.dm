GLOBAL_LIST_INIT(skill_types, subtypesof(/datum/skill))

/datum/skill
	var/name = "Skilling"
	var/title = "Skiller"
	var/desc = "the art of doing things"
	///Dictionary of modifier type - list of modifiers (indexed by level). 7 entries in each list for all 7 skill levels.
	var/modifiers = list(SKILL_SPEED_MODIFIER = list(1, 1, 1, 1, 1, 1, 1)) //Dictionary of modifier type - list of modifiers (indexed by level). 7 entries in each list for all 7 skill levels.
	///List Path pointing to the skill item reward that will appear when a user finishes leveling up a skill
	var/skill_item_path
	///List associating different messages that appear on level up with different levels
	var/list/levelUpMessages = list()
	///List associating different messages that appear on level up with different levels
	var/list/levelDownMessages = list()
	///If true then this skill is abstract, and you shouldnt get it
	var/is_abstract = FALSE

/datum/skill/proc/get_skill_modifier(modifier, level)
	return modifiers[modifier][level] //Levels range from 1 (None) to 7 (Legendary)
/**
 * new: sets up some lists.
 *
 *Can't happen in the datum's definition because these lists are not constant expressions
 */
/datum/skill/New()
	. = ..()
	levelUpMessages = list(span_nicegreen("What the hell is [name]? Tell an admin if you see this message."), //This first index shouldn't ever really be used
	span_nicegreen("I'm still pretty terrible at [name], but at least I'm not completely hopeless anymore."),
	span_nicegreen("I've finally reached an average level at [name]! No longer embarrassingly bad at this."),
	span_nicegreen("I'm getting better than average at [name]! Things are starting to click."),
	span_nicegreen("I feel quite skilled at [name] now. I'm definitely above most people."),
	span_nicegreen("After lots of practice, I've begun to truly understand the intricacies and surprising depth behind [name]. I now consider myself a master [title]."),
	span_nicegreen("Through incredible determination and effort, I've reached the peak of my [name] abilities. I'm finally able to consider myself a legendary [title]!") )
	levelDownMessages = list(span_nicegreen("I have somehow completely lost all understanding of [name]. Please tell an admin if you see this."),
	span_nicegreen("I'm getting really bad at [name] again. At least I still remember the basics..."),
	span_nicegreen("I'm slipping back to average at [name]. All that progress is fading away..."),
	span_nicegreen("I'm losing my edge at [name]. I'm no longer better than average..."),
	span_nicegreen("I'm losing my skill at [name]. I'll need to practice hard to get back up."),
	span_nicegreen("I feel like I'm losing my mastery of [name]."),
	span_nicegreen("I feel as though my legendary [name] skills have deteriorated. I'll need more intense training to recover my lost skills.") )

/**
 * level_gained: Gives skill levelup messages to the user
 *
 * Only fires if the xp gain isn't silent, so only really useful for messages.
 * Arguments:
 * * mind - The mind that you'll want to send messages
 * * new_level - The newly gained level. Can check the actual level to give different messages at different levels, see defines in skills.dm
 * * old_level - Similar to the above, but the level you had before levelling up.
 * * silent - Silences the announcement if TRUE
 */
/datum/skill/proc/level_gained(datum/mind/mind, new_level, old_level, silent)
	if(silent)
		return
	to_chat(mind.current, levelUpMessages[new_level]) //new_level will be a value from 1 to 6, so we get appropriate message from the 6-element levelUpMessages list
/**
 * level_lost: See level_gained, same idea but fires on skill level-down
 */
/datum/skill/proc/level_lost(datum/mind/mind, new_level, old_level, silent)
	if(silent)
		return
	to_chat(mind.current, levelDownMessages[old_level]) //old_level will be a value from 1 to 6, so we get appropriate message from the 6-element levelUpMessages list

/**
 * try_skill_reward: Checks to see if a user is eligable for a tangible reward for reaching a certain skill level
 *
 * Currently gives the user a special cloak when they reach a legendary level at any given skill
 * Arguments:
 * * mind - The mind that you'll want to send messages and rewards to
 * * new_level - The current level of the user. Used to check if it meets the requirements for a reward
 */
/datum/skill/proc/try_skill_reward(datum/mind/mind, new_level)
	if (new_level != SKILL_LEVEL_LEGENDARY)
		return
	if (!ispath(skill_item_path))
		to_chat(mind.current, span_nicegreen("My legendary [name] skill is quite impressive, though it seems the Professional [title] Association doesn't have any status symbols to commemorate my abilities with. I should let Centcom know of this travesty, maybe they can do something about it."))
		return
	if (LAZYFIND(mind.skills_rewarded, src.type))
		to_chat(mind.current, span_nicegreen("It seems the Professional [title] Association won't send me another status symbol."))
		return
	podspawn(list(
		"target" = get_turf(mind.current),
		"style" = /datum/pod_style/advanced,
		"spawn" = skill_item_path,
		"delays" = list(POD_TRANSIT = 150, POD_FALLING = 4, POD_OPENING = 30, POD_LEAVING = 30)
	))
	to_chat(mind.current, span_nicegreen("My legendary skill has attracted the attention of the Professional [title] Association. It seems they are sending me a status symbol to commemorate my abilities."))
	LAZYADD(mind.skills_rewarded, src.type)
