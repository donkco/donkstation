/datum/uplink_item/spywatch_kit
	name = "'No Time to Spy' Spywatch Kit"
	desc = "While it might look like an ordinary watch, in addition to sporting the latest LCD display and quartz timekeeping technologies, it also functions as a convert firearm! \
		The size constraints however, means that it is restricted to being single shot and chambered for a tiny cartridge, \
		but to make up for those limitations it is shipped with 'scylla's kiss' 2mm mollusk toxin bullets! \
		The toxin produced by the infamous zyn snail is capable of quickly blinding and disorienting the victim, giving the agent the upper hand in any fight."
	item = /obj/item/storage/box/ntraitor/spywatch_kit

	cost = 4
	purchasable_from = UPLINK_NTRAITORS

/datum/uplink_item/robomonkey
	name = "'Monkey Do' Radio Controlled Simine Simulant"
	desc = "Leveraging electromechanical \"remote control\" technology, this marvelous piece of equipment lets the agent conduct surveillance or monkey with the stations equipment while still maintaining their cover."
	item = /obj/item/remote_mob_controller/bot/monkey

	cost = 6
	purchasable_from = UPLINK_NTRAITORS

/datum/uplink_item/tracking_stickers
	name = "'Sticky Wicket' Tracking Stickers"
	desc  = "A pack of stickers that each conceal a thin film tracking device.\n\n \
 			Once affixed to an object they allow the agent to track the location of the sticker with a simple crew pinpointer, modified to recieve encrypted NT radio transmissions."
	item = /obj/item/storage/sticker_sheet/tracking
	cost = 2
	purchasable_from = UPLINK_NTRAITORS

/datum/uplink_item/tomahawk
	name = "'Sitting Bull' Tactical Tomahawk"
	desc = "A compact axe of Indian design, updated with new materials fit for the modern battlespace.\n \
			It can be utilzed to tactically dispatch the enemy in hand-to-hand combat  \
			or employed as a throwing weapon in order to neutralize him at some distrance."
	item = /obj/item/hatchet/tomahawk
	cost = 3
	purchasable_from = UPLINK_NTRAITORS

// STOCK TG ITEMS

/datum/uplink_item/mini_egun
	name = "Minaturized Energy Gun"
	desc = "A small energy gun, designed to be easily concealable in any manner known to the agent. "
	item = /obj/item/gun/energy/e_gun/mini
	cost = 4
	purchasable_from = UPLINK_NTRAITORS

/datum/uplink_item/knife
	name = "Combat Knife"
	desc = "A sturdy knife designed to give the agent the advantage in close-quarters combat."
	item = /obj/item/knife/combat
	cost = 3
	purchasable_from = UPLINK_NTRAITORS

/datum/uplink_item/disguise_kit
	name = "Disguise Kit"
	desc = "A small box containing various wigs, fake mustaches and other items to help the agent conceal their identity."

	cost = 3
	purchasable_from = UPLINK_NTRAITORS

/obj/item/storage/varnished
	name = "wooden box"
	desc = "A fine wooden box. Who knows what little trinkets it could hold?"
	icon_state = "varnished_box"

/obj/item/storage/varnished/disguise

/obj/item/storage/varnished/disguise/PopulateContents()
	. = ..()
	new /obj/item/clothing/head/wig/short_black(src)
	new /obj/item/clothing/head/wig/long_blonde(src)
	new /obj/item/clothing/head/wig/medium_brown(src)
	new /obj/item/clothing/mask/fakemoustache/biker(src)
	new /obj/item/clothing/mask/fakemoustache/italian(src)
	new /obj/item/clothing/mask/fakemoustache/beard(src)

/obj/item/clothing/head/wig/medium_brown
	color = COLOR_DARK_MODERATE_ORANGE
	hairstyle = "Emo"
	adjustablecolor = FALSE
	adjustablehairstyle = FALSE

/obj/item/clothing/head/wig/long_blonde
	color = COLOR_VERY_SOFT_YELLOW
	hairstyle = "Shoulder-length Hair"
	adjustablecolor = FALSE
	adjustablehairstyle = FALSE

/obj/item/clothing/head/wig/short_black
	color = COLOR_ALMOST_BLACK
	hairstyle = "Business Hair 2"
	adjustablecolor = FALSE
	adjustablehairstyle = FALSE

/obj/item/clothing/mask/fakemoustache/biker
	worn_icon = 'icons/mob/human/human_face.dmi'
	worn_icon_state = "facial_hogan"
	color = COLOR_DARK_MODERATE_ORANGE

/obj/item/clothing/mask/fakemoustache/beard
	worn_icon = 'icons/mob/human/human_face.dmi'
	worn_icon_state = "facial_fullbeard"
	color = COLOR_ALMOST_BLACK

/obj/item/storage/sticker_sheet
	icon = 'icons/obj/storage/donk_storage.dmi'
	icon_state = "sheet"
	/// list of possible offset for each size of sticker
	var/list/sticker_spots = list(
		list(7, 8) = list(list(21, 20)),
		list(8, 5) = list(list(4, 3), list(13, 3), list(8, 9), list(4, 24)),
		list(8, 6) = list(list(3, 12)),
		list(7, 4) = list(list(12, 20), list(12, 25)),
		list(6, 6) = list(list(16, 12)),
		list(6, 5) = list(list(21, 15)),
		list(5, 5) = list(list(22, 8), list(4, 18)),
		list(5, 4) = list(list(22, 3), list(12, 15)),
		list(3, 2) = list(list(4, 9), list(17, 9)),
		list(2, 1) = list(list(24, 13)),
	)



/obj/item/storage/sticker_sheet/tracking
