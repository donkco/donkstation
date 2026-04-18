/datum/preference/text/place_of_birth
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "place_of_birth"
	savefile_identifier = PREFERENCE_CHARACTER
	maximum_value_length = 64
	can_randomize = FALSE

/datum/preference/text/place_of_birth/should_show_on_page(preference_tab)
	return FALSE

/datum/preference/text/place_of_birth/apply_to_human(mob/living/carbon/human/target, value)
	return

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
