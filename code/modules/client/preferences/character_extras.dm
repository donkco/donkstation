/datum/preference/choiced/place_of_birth
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "place_of_birth"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/place_of_birth/should_show_on_page(preference_tab)
	return FALSE

/datum/preference/choiced/place_of_birth/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/place_of_birth/init_possible_values()
	var/list/values = list()
	for(var/pob_id in GLOB.place_of_birth_list)
		values += GLOB.place_of_birth_list[pob_id]
	return values

/datum/preference/choiced/place_of_birth/create_default_value()
	return GLOB.place_of_birth_list["earth"]

/datum/preference/choiced/place_of_birth/serialize(input)
	var/datum/place_of_birth/pob = input
	return pob.id

/datum/preference/choiced/place_of_birth/deserialize(input, datum/preferences/preferences)
	var/datum/place_of_birth/pob = GLOB.place_of_birth_list[sanitize_inlist(input, get_choices_serialized(), serialize(create_default_value()))]
	return pob || create_default_value()

/datum/place_of_birth
	abstract_type = /datum/place_of_birth
	var/id = "unknown"
	var/name = "Unknown"

/datum/place_of_birth/earth
	id = "earth"
	name = "Earth"

/datum/place_of_birth/mars
	id = "mars"
	name = "Mars"



/datum/preference/name/last_name
	savefile_key = "last_name"
	allow_empty = TRUE
	can_randomize = FALSE

/datum/preference/name/last_name/should_show_on_page(preference_tab)
	return FALSE

/datum/preference/name/last_name/create_informed_default_value(datum/preferences/preferences)
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/last = generate_random_name_species_based(
		preferences.read_preference(/datum/preference/choiced/gender),
		FALSE,
		species_type,
		name_parts = GENERATE_NAME_LAST,
	)
	return last || ""

/datum/preference/name/last_name/apply_to_human(mob/living/carbon/human/target, value)
	return
