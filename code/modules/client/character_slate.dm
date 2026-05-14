/**
 * Standalone TGUI datum for the Character Slate window.
 * Displays the 5-slot job priority queue and allows editing.
 * Stored on /datum/preferences as character_slate.
 */
/datum/character_slate
	var/datum/preferences/prefs

/datum/character_slate/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/character_slate/Destroy()
	prefs = null
	return ..()

/datum/character_slate/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/job_selection),
	)

/datum/character_slate/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "CharacterSlate", "Job Slate")
		ui.open()

/datum/character_slate/ui_state(mob/user)
	return GLOB.always_state

/datum/character_slate/ui_status(mob/user, datum/ui_state/state)
	return user.client == prefs.parent ? UI_INTERACTIVE : UI_CLOSE

/datum/character_slate/ui_data(mob/user)
	var/list/data = list()

	if(!islist(prefs.job_slate) || length(prefs.job_slate) != 5)
		prefs.job_slate = prefs.default_job_slate()

	var/list/slots_out = list()
	for(var/i in 1 to 5)
		var/list/entry = prefs.job_slate[i]
		if(!islist(entry))
			entry = list("char_slot" = 0, "job" = "")
		var/char_slot = entry["char_slot"]
		var/char_name = ""
		if(char_slot > 0)
			if(char_slot == prefs.default_slot)
				char_name = prefs.read_preference(/datum/preference/name/real_name) || "Unnamed"
			else
				var/save_data = prefs.savefile?.get_entry("character[char_slot]")
				char_name = save_data?["real_name"] || "Unnamed"
		slots_out += list(list(
			"index"     = i,
			"char_slot" = char_slot,
			"char_name" = char_name,
			"job"       = entry["job"],
		))
	data["slate_slots"] = slots_out

	var/list/occupied = list()
	for(var/list/entry as anything in prefs.job_slate)
		if(entry["job"] && entry["job"] != "")
			occupied |= entry["job"]
	data["slate_occupied_jobs"] = occupied
	data["overflow_char_slot"] = prefs.overflow_char_slot

	return data

/datum/character_slate/ui_static_data(mob/user)
	var/list/data = list()

	var/list/characters_out = list()
	for(var/slot_i in 1 to prefs.max_save_slots)
		var/created = FALSE
		var/c_name = ""
		if(slot_i == prefs.default_slot)
			created = prefs.character_created
			c_name = created ? (prefs.read_preference(/datum/preference/name/real_name) || "Unnamed") : ""
		else
			var/save_data = prefs.savefile?.get_entry("character[slot_i]")
			created = !!(save_data?["character_created"])
			if(created)
				c_name = save_data?["real_name"] || "Unnamed"
		if(created)
			characters_out += list(list("slot" = slot_i, "name" = c_name))
	data["slate_characters"] = characters_out

	var/list/available_jobs_out = list()
	for(var/slot_i in 1 to prefs.max_save_slots)
		var/list/job_types = prefs.get_available_jobs_for_character(slot_i)
		if(!length(job_types))
			continue
		var/list/job_list = list()
		for(var/job_type in job_types)
			var/datum/job/job = SSjob.get_job_type(job_type)
			if(!job)
				continue
			var/dept_name = ""
			if(job.department_for_prefs)
				var/datum/job_department/dept = SSjob.get_department_type(job.department_for_prefs)
				dept_name = dept ? initial(dept.department_name) : ""
			job_list += list(list(
				"title"           = job.title,
				"department"      = dept_name,
				"total_positions" = job.total_positions,
			))
		available_jobs_out["[slot_i]"] = job_list
	data["slate_available_jobs"] = available_jobs_out

	return data

/datum/character_slate/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("slate_set_character")
			var/index = text2num(params["index"])
			var/char_slot = text2num(params["char_slot"])
			if(!isnum(index) || index < 1 || index > 5)
				return FALSE
			if(!isnum(char_slot) || char_slot < 0 || char_slot > prefs.max_save_slots)
				return FALSE
			var/list/slot_entry = prefs.job_slate[index]
			if(!islist(slot_entry))
				return FALSE
			slot_entry["char_slot"] = char_slot
			// Validate existing job for new character; clear if no longer valid
			var/cur_job = slot_entry["job"]
			if(cur_job && char_slot > 0)
				var/list/avail = prefs.get_available_jobs_for_character(char_slot)
				var/valid = FALSE
				for(var/jtype in avail)
					var/datum/job/j = SSjob.get_job_type(jtype)
					if(j && j.title == cur_job)
						valid = TRUE
						break
				if(!valid)
					slot_entry["job"] = ""
			else
				slot_entry["job"] = ""
			prefs.save_character()
			return TRUE

		if("slate_set_job")
			var/index = text2num(params["index"])
			var/job_title = params["job"]
			if(!isnum(index) || index < 1 || index > 5)
				return FALSE
			if(!istext(job_title))
				return FALSE
			var/list/set_entry = prefs.job_slate[index]
			if(!islist(set_entry))
				return FALSE
			var/char_slot = set_entry["char_slot"]
			if(!char_slot)
				return FALSE
			var/list/avail = prefs.get_available_jobs_for_character(char_slot)
			var/valid = FALSE
			for(var/jtype in avail)
				var/datum/job/j = SSjob.get_job_type(jtype)
				if(j && j.title == job_title)
					valid = TRUE
					break
			if(!valid)
				return FALSE
			// Clear the same job from any other slot so duplicates don't persist
			for(var/j in 1 to 5)
				if(j == index)
					continue
				var/list/other = prefs.job_slate[j]
				if(islist(other) && other["job"] == job_title)
					other["job"] = ""
					break
			set_entry["job"] = job_title
			prefs.save_character()
			return TRUE

		if("slate_clear_slot")
			var/index = text2num(params["index"])
			if(!isnum(index) || index < 1 || index > 5)
				return FALSE
			var/list/clear_entry = prefs.job_slate[index]
			if(!islist(clear_entry))
				return FALSE
			clear_entry["char_slot"] = 0
			clear_entry["job"] = ""
			prefs.save_character()
			return TRUE

		if("slate_reorder_slots")
			var/from = text2num(params["from"])
			var/towards = text2num(params["to"])
			if(!isnum(from) || !isnum(towards) || from == towards)
				return FALSE
			if(from < 1 || from > 5 || towards < 1 || towards > 5)
				return FALSE
			var/list/moved = prefs.job_slate[from]
			if(!islist(moved))
				return FALSE
			prefs.job_slate.Cut(from, from + 1)
			// Insert a null placeholder first — passing a list to Insert() expands its
			// contents rather than inserting the list object, which corrupts the slate.
			prefs.job_slate.Insert(towards, null)
			prefs.job_slate[towards] = moved
			prefs.save_character()
			return TRUE

		if("slate_set_overflow")
			var/char_slot = text2num(params["char_slot"])
			if(!isnum(char_slot) || char_slot < 0 || char_slot > prefs.max_save_slots)
				return FALSE
			if(char_slot > 0)
				var/exists = FALSE
				if(char_slot == prefs.default_slot)
					exists = prefs.character_created
				else
					var/save_data = prefs.savefile?.get_entry("character[char_slot]")
					exists = !!(save_data?["character_created"])
				if(!exists)
					return FALSE
			prefs.overflow_char_slot = char_slot
			prefs.save_character()
			return TRUE
