/// TGUI-backed datum for the CharacterContract screen, owned by /datum/preferences.
/datum/character_contract
	var/datum/preferences/prefs
	///The archetype ID the user has highlighted in the picker but not yet confirmed.
	var/pending_archetype_id
	/// Base64-encoded PNG snapshot of the character — transparent background, no BYOND map view needed.
	var/preview_b64
	/// Guard against concurrent preview generation.
	var/generating_preview = FALSE
	/// Set to TRUE when confirm_archetype is performed so the TSX plays the quirk reveal animation exactly once.
	var/play_reveal_anim = FALSE

/datum/character_contract/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/character_contract/ui_interact(mob/user, datum/tgui/ui)
	var/is_new_open = !SStgui.try_update_ui(user, src, ui)
	if(is_new_open)
		ui = new(user, src, "CharacterContract")
		ui.open()
		// Always refresh the preview when the UI is freshly opened so the
		// correct character slot is shown, not a stale cached snapshot.
		if(prefs.character_created && !generating_preview)
			preview_b64 = null
	if(prefs.character_created && !preview_b64 && !generating_preview)
		INVOKE_ASYNC(src, PROC_REF(generate_preview_async))

/datum/character_contract/proc/generate_preview_async()
	if(generating_preview || QDELETED(src))
		return
	generating_preview = TRUE
	var/mob/living/carbon/human/dummy/mannequin = new()
	var/mutable_appearance/appearance = prefs?.render_new_preview_appearance(mannequin, FALSE)
	var/icon/flat
	if(appearance && !QDELETED(src))
		flat = getFlatIcon(appearance, defdir = SOUTH, no_anim = TRUE)
	qdel(mannequin)
	if(QDELETED(src))
		generating_preview = FALSE
		return
	preview_b64 = flat ? icon2base64(flat) : null
	generating_preview = FALSE
	SStgui.update_uis(src)

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
	data["secretary_points"] = prefs.secretary_points

	// Build archetype list from the subsystem
	var/list/archetype_list = list()
	for(var/archetype_type in SScharacters.all_archetypes)
		var/datum/character_archetype/arch = SScharacters.all_archetypes[archetype_type]
		archetype_list += list(list(
			"name" = arch.name,
			"id" = arch.archetype_id,
			"cost" = arch.cost,
			"affordable" = (arch.cost <= prefs.secretary_points),
		))
	data["archetypes"] = archetype_list
	data["selected_archetype"] = pending_archetype_id

	// Contract page data — build from the player's rolled quirks
	var/list/contract_quirks_data = list()
	for(var/quirk_name in prefs.all_quirks)
		var/quirk_type = SSquirks.quirks[quirk_name]
		var/datum/quirk/prototype = SSquirks.quirk_prototypes[quirk_type]
		if(!prototype)
			continue
		contract_quirks_data += list(list(
			"name"         = quirk_name,
			"category"     = prototype.quirk_category,
			"flavor_text"  = prototype.contract_flavor_text,
			"top_image"    = prototype.contract_top_image,
			"bottom_image" = prototype.contract_bottom_image,
		))
	data["contract_quirks"] = contract_quirks_data
	data["play_reveal_anim"] = play_reveal_anim
	data["preview_icon"] = preview_b64
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
			// Re-validate pending ID against known archetypes and check affordability
			var/datum/character_archetype/chosen_arch = null
			for(var/archetype_type in SScharacters.all_archetypes)
				var/datum/character_archetype/arch = SScharacters.all_archetypes[archetype_type]
				if(arch.archetype_id == pending_archetype_id)
					chosen_arch = arch
					break
			if(!chosen_arch)
				return FALSE
			// Check player has enough SP
			if(prefs.secretary_points < chosen_arch.cost)
				return FALSE
			prefs.adjust_secretary_points(-chosen_arch.cost)
			prefs.archetype_id = pending_archetype_id
			prefs.character_created = TRUE
			// Roll quirks and register them — result is assoc typepath -> QUIRK_CATEGORY_*
			var/list/rolled = chosen_arch.roll_quirks()
			for(var/quirk_type in rolled)
				var/datum/quirk/prototype = SSquirks.quirk_prototypes[quirk_type]
				if(prototype)
					prefs.all_quirks += prototype.name
			prefs.mark_character_prefs_dirty()
			prefs.save_character()
			play_reveal_anim = TRUE
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
		if("open_preferences")
			preview_b64 = null // Invalidate cache — will regenerate when prefs closes
			prefs.current_window = PREFERENCE_TAB_CHARACTER_PREFERENCES
			prefs.update_static_data(ui.user)
			prefs.ui_interact(ui.user)
			return TRUE
		if("clear_reveal_anim")
			play_reveal_anim = FALSE
			return TRUE
	return FALSE
