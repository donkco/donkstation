///Portable record player, can play vinyl records.
/obj/item/record_player
	name = "record player"
	desc = "A portable record player with a fold-out stylus arm and a small built-in speaker."
	icon = 'icons/obj/machines/vinylplayer.dmi'
	icon_state = "vinyl_player"
	base_icon_state = "vinyl_player"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/record_player/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/vinyl_player, FALSE)
