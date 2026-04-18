/datum/character_archetype
	var/name = "Generic John"
	///Unique string ID for this archetype, matches a CHARACTER_ARCHETYPE_X define. Must be set on every subtype.
	var/archetype_id
	///Cost of the archetype in SP
	var/cost = 50
	///Associative list of positive quirks to roll associated with their selection weight
	var/list/positive_quirk_table
	///Associative list of negative quirks to roll associated with their selection weight
	var/list/negative_quirk_table
	///Associative list of neutral quirks to roll associated with their selection weight
	var/list/neutral_quirk_table


/datum/character_archetype/intern
	name = "Intern"
	archetype_id = CHARACTER_ARCHETYPE_INTERN
	cost = 0

/datum/character_archetype/laborer
	name = "Laborer"
	archetype_id = CHARACTER_ARCHETYPE_LABORER


/datum/character_archetype/manager
	name = "Manager"
	archetype_id = CHARACTER_ARCHETYPE_MANAGER
	cost = 100

/datum/character_archetype/scholar
	name = "Scholar"
	archetype_id = CHARACTER_ARCHETYPE_SCHOLAR
	cost = 200
