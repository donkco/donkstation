/// TGUI-backed datum for the CharacterContract screen, owned by /datum/preferences.
/datum/character_contract
	var/datum/preferences/prefs
	///The archetype ID the user has highlighted in the picker but not yet confirmed.
	var/pending_archetype_id

/datum/character_contract/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/character_contract/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterContract")
		ui.open()

/datum/character_contract/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/charactercontract),
	)

/datum/character_contract/ui_state(mob/user)
	return GLOB.always_state

/datum/character_contract/ui_status(mob/user, datum/ui_state/state)
	return user.client == prefs.parent ? UI_INTERACTIVE : UI_CLOSE

/datum/character_contract/ui_data(mob/user)
	var/list/data = list()

	// Archetype picker data — always sent so the frontend knows which page to show
	data["character_created"] = prefs.character_created

	// Build archetype list from the subsystem
	var/list/archetype_list = list()
	for(var/archetype_type in SScharacters.all_archetypes)
		var/datum/character_archetype/arch = SScharacters.all_archetypes[archetype_type]
		archetype_list += list(list(
			"name" = "[arch.name] [arch.cost]SP",
			"id" = arch.archetype_id,
		))
	data["archetypes"] = archetype_list
	data["selected_archetype"] = pending_archetype_id

	// Contract page data
	data["trait_title_1"] = "Blueblooded"
	data["trait_title_2"] = "Nearsighted"
	data["trait_title_3"] = "Polygamist"
	data["trait_desc_1"] = "They are the ((Prince)) of ((Persia)) over at ((Ubisoft)).\n\nDespite some mixed assessments of their compency & general demeanor, it might be prudent to find a place for them."
	data["trait_desc_2"] = "The physical examination has shown that their eyesight is very poor.\n\nThey will need corrective eyewear to see much of anything\n\nLiability?"
	data["trait_desc_3"] = "They belong to a family that practices multiple marriage.\n\nI've been told this is quite ordinary in their culture\n\nStrange!"
	data["first_name"] = prefs.read_preference(/datum/preference/name/real_name)
	data["last_name"] = prefs.read_preference(/datum/preference/name/last_name)
	data["age"] = prefs.read_preference(/datum/preference/numeric/age)
	data["place_of_birth"] = prefs.read_preference(/datum/preference/text/place_of_birth)
	data["gender"] = prefs.read_preference(/datum/preference/choiced/gender)
	return data

/datum/character_contract/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/datum/preference/pref
	switch(action)
		// ── Archetype picker (page 1) ─────────────────────────────────────
		if("play_stamp_sound")
			ui.user.playsound_local(usr, 'sound/items/rubber_stamp.ogg', 40, 1)
			return TRUE

		if("select_archetype")
			// Silently reject if character is already created
			if(prefs.character_created)
				return FALSE
			var/incoming_id = params["id"]
			// Validate the incoming ID against known archetypes
			for(var/archetype_type in SScharacters.all_archetypes)
				var/datum/character_archetype/arch = SScharacters.all_archetypes[archetype_type]
				if(arch.archetype_id == incoming_id)
					pending_archetype_id = incoming_id
					return TRUE
			return FALSE

		if("confirm_archetype")
			// Silently reject if already created or nothing selected
			if(prefs.character_created || isnull(pending_archetype_id))
				return FALSE
			// Re-validate pending ID against known archetypes
			var/valid = FALSE
			for(var/archetype_type in SScharacters.all_archetypes)
				var/datum/character_archetype/arch = SScharacters.all_archetypes[archetype_type]
				if(arch.archetype_id == pending_archetype_id)
					valid = TRUE
					break
			if(!valid)
				return FALSE
			prefs.archetype_id = pending_archetype_id
			prefs.character_created = TRUE
			prefs.save_character()
			return TRUE

		// ── Contract details (page 2) ─────────────────────────────────────
		if("set_first_name")
			pref = GLOB.preference_entries[/datum/preference/name/real_name]
			if(!prefs.write_preference(pref, params["value"]))
				return FALSE
			return TRUE
		if("set_last_name")
			pref = GLOB.preference_entries[/datum/preference/name/last_name]
			return prefs.write_preference(pref, params["value"])
		if("set_age")
			pref = GLOB.preference_entries[/datum/preference/numeric/age]
			if(!prefs.write_preference(pref, params["value"]))
				return FALSE
			return TRUE
		if("set_place_of_birth")
			pref = GLOB.preference_entries[/datum/preference/text/place_of_birth]
			return prefs.write_preference(pref, params["value"])
		if("set_gender")
			pref = GLOB.preference_entries[/datum/preference/choiced/gender]
			if(!prefs.write_preference(pref, params["value"]))
				return FALSE
			return TRUE
	return FALSE
