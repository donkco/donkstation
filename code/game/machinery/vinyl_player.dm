///Stationary vinyl player, can play vinyl records.
/obj/machinery/vinyl_player
	name = "vinyl player"
	desc = "A record player for vinyl discs."
	icon = 'icons/obj/machines/music.dmi'
	icon_state = "jukebox"
	base_icon_state = "jukebox"
	verb_say = "plays"
	density = TRUE
	anchored = TRUE

/obj/machinery/vinyl_player/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/vinyl_player)

/obj/machinery/vinyl_player/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(held_item?.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = anchored ? "Unsecure" : "Secure"
		return CONTEXTUAL_SCREENTIP_SET
	return NONE

/obj/machinery/vinyl_player/wrench_act(mob/living/user, obj/item/tool)
	if(default_unfasten_wrench(user, tool) == SUCCESSFUL_UNFASTEN)
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING
