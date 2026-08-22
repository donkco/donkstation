/datum/attribute_panel
	var/datum/mind/targetmind
	var/client/holder //client of whoever is using this datum

/datum/attribute_panel/New(user, datum/mind/mind)//H can either be a client or a mob due to byondcode(tm)
	targetmind = mind
	if (istype(user,/client))
		var/client/userClient = user
		holder = userClient //if its a client, assign it to holder
	else
		var/mob/userMob = user
		holder = userMob.client //if its a mob, assign the mob's client to holder

/datum/attribute_panel/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/attribute_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AttributePanel")
		ui.open()

/datum/attribute_panel/ui_data(mob/user)
	var/list/data = list()

	var/list/skills = list()
	data["skills"] = skills

	var/datum/mind/targetmind = user.mind
	if(!targetmind)
		return
	for (var/type in GLOB.skill_types)
		var/datum/skill/skill = GetSkillRef(type)
		var/lvl_base = targetmind.get_base_skill_level(type)
		var/lvl_bonus = targetmind.get_skill_bonus(type)
		var/lvl_name = uppertext(targetmind.get_skill_level_name(type))

		var/list/skilldata = list(
			"name" = skill.name,
			"desc" = skill.desc,
			"title" = skill.title,
			"lvl_base" = lvl_base,
			"lvl_bonus" = lvl_bonus,
			"lvl_name" = lvl_name,
		)

		skills[++skills.len] = skilldata
