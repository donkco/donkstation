/obj/item/remote_mob_controller
	name = "RC controller"
	desc = "A device that employs invisible rays, quite like those picked up by an ordinary household radio, in order to remotely operate machinery."
	icon = 'icons/obj/antags/nt_agent.dmi'
	icon_state = "rc_controller"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/remote_mob_controller/bot
	var/mob/living/assigned_bot
	///Can new bots be assigned to this controller manually?
	var/can_assign_bots = FALSE

/obj/item/remote_mob_controller/bot/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!can_assign_bots)
		return
	if(isliving(interacting_with)) /// This should become a generic bot type check if we add more bots later. For now technically any living mob counts.
		if(assigned_bot.stat == DEAD)
			to_chat(user, span_warning("Error: Linking module destroyed."))
			return
		assigned_bot = interacting_with
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		balloon_alert(user, "[assigned_bot] is now assigned to this controller.")
		return ITEM_INTERACT_SUCCESS
	return

/obj/item/remote_mob_controller/bot/attack_self(mob/user)
	if(!QDELETED(assigned_bot))
		if(assigned_bot.stat == DEAD)
			to_chat(user, span_warning("Warning: No connection found with bot."))
			return
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		balloon_alert(user, "You have started controlling [assigned_bot.name].")
		assigned_bot.AddComponent(/datum/component/remote_control, user.mind, user,  FALSE)
		return ITEM_INTERACT_SUCCESS
	else
		to_chat(user, span_warning("Error: No bot connection found!"))
	return

/obj/item/remote_mob_controller/bot/dropped(mob/user, silent)
	. = ..()
	if(QDELETED(assigned_bot))
		return
	if(assigned_bot.GetComponent(/datum/component/remote_control)) //this is kind of shit. An alternate solution would be to pass this object to the remote controller as a "link" and register for being dropped. Maybe later.
		assigned_bot.GetComponent(/datum/component/remote_control).return_mind_to_controller()


/obj/item/remote_mob_controller/bot/monkey
	///Has the monkey been created?
	var/has_monkey_been_made = FALSE
	///The name to give the monkey when it's created
	var/monkey_name = "Robotic George"

/obj/item/remote_mob_controller/bot/monkey/attack_self(mob/user)
	if(has_monkey_been_made)
		return ..()

	var/chosen_name = tgui_input_text(user, "What will you name your robotic monkey?", "Name your monkey", monkey_name, max_length = MAX_NAME_LEN)
	if(chosen_name && length(trim(chosen_name)))
		monkey_name = trim(chosen_name)

	has_monkey_been_made = TRUE
	to_chat(user, span_notice("A small cube drops out of [src] and quickly unfolds into a robotic monkey."))
	assigned_bot = new /mob/living/carbon/human/species/androidmonkey(get_turf(src))
	assigned_bot.fully_replace_character_name(assigned_bot.real_name, monkey_name)
	assigned_bot.Knockdown(2 SECONDS)
