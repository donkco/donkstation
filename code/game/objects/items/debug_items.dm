/* This file contains standalone items for debug purposes. */
/obj/item/debug
	abstract_type = /obj/item/debug

/obj/item/debug/human_spawner
	name = "human spawner"
	desc = "Spawn a human by aiming at a turf and clicking. Use in hand to change type."
	icon = 'icons/obj/weapons/guns/magic.dmi'
	icon_state = "nothingwand"
	inhand_icon_state = "wand"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/datum/species/selected_species
	var/valid_species = list()

/obj/item/debug/human_spawner/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return interact_with_atom(interacting_with, user, modifiers)

/obj/item/debug/human_spawner/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isturf(interacting_with))
		var/mob/living/carbon/human/H = new /mob/living/carbon/human(interacting_with)
		if(selected_species)
			H.set_species(selected_species)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/debug/human_spawner/attack_self(mob/user)
	..()
	var/choice = input("Select a species", "Human Spawner", null) in sortTim(GLOB.species_list, GLOBAL_PROC_REF(cmp_text_asc))
	selected_species = GLOB.species_list[choice]

/obj/item/debug/omnitool
	name = "omnitool"
	desc = "The original hypertool, born before them all. Use it in hand to unleash its true power."
	icon = 'icons/obj/weapons/club.dmi'
	icon_state = "hypertool"
	inhand_icon_state = "hypertool"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	toolspeed = 0.1
	tool_behaviour = null

/obj/item/debug/omnitool/examine()
	. = ..()
	. += " The mode is: [tool_behaviour]"

/obj/item/debug/omnitool/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/debug/omnitool/get_all_tool_behaviours()
	return GLOB.all_tool_behaviours

/obj/item/debug/omnitool/attack_self(mob/user)
	if(!user)
		return
	var/tool_result = show_radial_menu(user, src, GLOB.tool_to_image, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	tool_behaviour = tool_result

/obj/item/debug/omnitool/item_spawner
	name = "spawntool"
	color = COLOR_ADMIN_PINK

/obj/item/debug/omnitool/item_spawner/attack_self(mob/user)
	if(!user || !user.client)
		return
	var/path = text2path(tgui_input_text(user, "Insert an item typepath to spawn", "ADMINS ONLY. FUCK AROUND AND FIND OUT."))
	if(!path)
		return
	var/choice = tgui_alert(user, "Subtypes only?",, list("Yes", "No"))
	if(!choice)
		return
	if(!user.client.holder)
		if(!isliving(user))
			return
		var/mob/living/living_user = user
		to_chat(user, span_warning("As you try to use [src], you hear strange tearing sounds, as if the coder gods were attempting to reach out and choke you themselves."))
		playsound(src, 'sound/effects/dimensional_rend.ogg')
		sleep(4 SECONDS)
		var/confirmation = tgui_alert(user, "Are you certain you want to do that?", "Admins Only. Last Chance.", list("Yes", "No"))
		if(!confirmation || confirmation == ("No"))
			return
		if(!user.client.holder) //safety if the admin readmined to save their ass lol.
			to_chat(user, span_reallybig("You shouldn't have done that..."))
			playsound(src, 'sound/mobs/non-humanoids/cyborg/borg_deathsound.ogg')
			sleep(3 SECONDS)
			living_user.investigate_log("has been gibbed by [src].", INVESTIGATE_DEATHS)
			living_user.gib(DROP_ALL_REMAINS)
			return
	var/turf/loc_turf = get_turf(src)
	for(var/spawn_atom in (choice == "No" ? typesof(path) : subtypesof(path)))
		new spawn_atom(loc_turf)


/obj/item/debug/celestial_conductor
	name = "ȣ∇ɁႣႩႿỼẟ"
	desc = "ȣ∇⊙Ɂթ ႿჅ ɁƟǂ ႣႩ ႣႩ |"
	icon = 'icons/obj/donk_artifacts.dmi'
	icon_state = "celestial_conductor"
	var/device_ready = FALSE
	var/starlight_color = COLOR_STARLIGHT
	var/starlight_power = 1
	var/starlight_range = 2

/obj/item/debug/celestial_conductor/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/lore, string_list_of_assoc_lists(list( \
		list( \
			"skill" = /datum/skill/lore/alien, \
			"min_level" = SKILL_LEVEL_EXPERT, \
			"article" = "a", \
			"name" = "celestial conductor", \
			"desc" = "A device capable of bendings even the brightest star to its will.", \
		))), show_only_on_examine_more = FALSE)

/obj/item/debug/celestial_conductor/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "[icon_state]_emissive", src, alpha = 128, effect_type = EMISSIVE_NO_BLOOM)

/obj/item/debug/celestial_conductor/attack_self(mob/user, modifiers)
	. = ..()
	if(!device_ready || !starlight_color)
		playsound(src, 'sound/effects/industrial_scan/industrial_scan3.ogg', 100, frequency = 28 KILO HERTZ)
		return

	playsound(src, 'sound/effects/chemistry/shockwave_explosion.ogg', 100, TRUE)
	set_starlight(starlight_color, starlight_range, starlight_power)
	device_ready = FALSE

/obj/item/debug/celestial_conductor/attack_self_secondary(mob/user, modifiers)
	starlight_color = tgui_color_picker(user, "⊙ʭ∇Ͽ", "ȣ∇ɁႣႩႿỼẟ", default = starlight_color || COLOR_STARLIGHT) || COLOR_STARLIGHT
	starlight_range = tgui_input_number(user, "Ỽẟ∇Ͽ", "ȣ∇ɁႣႩႿỼẟ", default = starlight_range || 0, round_value = FALSE) || 0
	starlight_power = tgui_input_number(user, "ỼҨՊ∇Ͽ", "ȣ∇ɁႣႩႿỼẟ", default = starlight_power || 0, round_value = FALSE) || 0
	playsound(src, 'sound/effects/magic/cosmic_expansion.ogg', 40, TRUE)
	device_ready = TRUE
