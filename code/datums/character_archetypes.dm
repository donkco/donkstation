/datum/character_archetype
	var/name = "Generic John"
	///Unique string ID for this archetype, matches a CHARACTER_ARCHETYPE_X define. Must be set on every subtype.
	var/archetype_id
	///Cost of the archetype in SP
	var/cost = 50
	///Weighted table of species typepaths to roll from when this archetype is confirmed.
	var/list/species_table = list(
		/datum/species/human = 5,
		/datum/species/lizard = 1,
		/datum/species/ethereal = 1,
	)

	///Dont have more than 3 quirks in total, we hardcode the UI for 3 right now. :(
	///Amount of positive quirks to roll.
	var/amount_of_positive_quirks = 1
	///Amount of negative quirks to roll.
	var/amount_of_negative_quirks = 1
	///Amount of neutral quirks to roll.
	var/amount_of_neutral_quirks = 1

	///Associative list of positive quirks to roll associated with their selection weight
	var/list/positive_quirk_table = list(
		/datum/quirk/alcohol_tolerance = 1,\
		/datum/quirk/chipped = 1,\
		/datum/quirk/drunkhealing = 1,\
	)
	///Associative list of negative quirks to roll associated with their selection weight
	var/list/negative_quirk_table = list(
		/datum/quirk/claustrophobia = 1,\
		/datum/quirk/item_quirk/blindness = 1,\
		/datum/quirk/body_purist = 1,\
)
	///Associative list of neutral quirks to roll associated with their selection weight
	var/list/neutral_quirk_table = list(
		/datum/quirk/item_quirk/bald = 1,\
		/datum/quirk/heterochromatic = 1,\
	)

/// Returns an associative list of typepath -> QUIRK_CATEGORY_* string
/datum/character_archetype/proc/roll_quirks()
	var/list/rolled_quirks = list()

	var/possible_positive_quirks = positive_quirk_table.Copy()
	var/possible_negative_quirks = negative_quirk_table.Copy()
	var/possible_neutral_quirks = neutral_quirk_table.Copy()

	for(var/i in 1 to amount_of_positive_quirks)
		roll_single_quirk(possible_positive_quirks, rolled_quirks, QUIRK_CATEGORY_POSITIVE)

	for(var/i in 1 to amount_of_negative_quirks)
		roll_single_quirk(possible_negative_quirks, rolled_quirks, QUIRK_CATEGORY_NEGATIVE)

	for(var/i in 1 to amount_of_neutral_quirks)
		roll_single_quirk(possible_neutral_quirks, rolled_quirks, QUIRK_CATEGORY_NEUTRAL)

	return rolled_quirks

/datum/character_archetype/proc/roll_single_quirk(list/quirk_list, list/result, category)
	var/selected_quirk = pick_weight(quirk_list)
	quirk_list.Remove(selected_quirk)
	if(selected_quirk)
		result[selected_quirk] = category

/// Rolls a species typepath from species_table using weighted random selection.
/// Returns a /datum/species typepath.
/datum/character_archetype/proc/roll_species()
	return pick_weight(species_table)

/datum/character_archetype/intern
	name = "Intern"
	archetype_id = CHARACTER_ARCHETYPE_INTERN
	cost = 0
	amount_of_positive_quirks = 0
	amount_of_negative_quirks = 3
	amount_of_neutral_quirks = 0

/datum/character_archetype/laborer
	name = "Laborer"
	archetype_id = CHARACTER_ARCHETYPE_LABORER
	cost = 50


/datum/character_archetype/manager
	name = "Manager"
	archetype_id = CHARACTER_ARCHETYPE_MANAGER
	cost = 100

/datum/character_archetype/scholar
	name = "Scholar"
	archetype_id = CHARACTER_ARCHETYPE_SCHOLAR
	cost = 200
