// Donk Categproes

/datum/uplink_category/surverilance
	name ="Espionage and Surveillance"
	weight = 3

/datum/uplink_category/disguise
	name ="Disguise and Deceit"
	weight = 3

// NT AGENT ITEMS

/datum/uplink_item/spywatch_kit
	name = "'No Time to Spy' Spywatch Kit"
	desc = "While it might look like an ordinary watch, in addition to sporting the latest LCD display and quartz timekeeping technologies, it also functions as a convert firearm!\n\n \
		The size constraints however, means that it is restricted to being single shot and chambered for a tiny cartridge, \
		but to make up for those limitations it is shipped with 'scylla's kiss' 2mm mollusk toxin bullets!\n \
		The toxin produced by the infamous zyn snail is capable of quickly blinding and disorienting the victim, giving the agent the upper hand in any fight."
	item = /obj/item/storage/box/ntraitor/spywatch_kit

	cost = 4
	purchasable_from = UPLINK_NTRAITORS
	category = /datum/uplink_category/stealthy

/datum/uplink_item/ammo_twomm_scylla
	name ="'Scylla's Kiss' 2mm mollusk toxin box"
	desc = "These bullets, while small, are coated with a rare shellfish toxin which exhibits a remarable effect on the human optic nerve.\n The rapid blidning action allows the agent to either escape or dispatch them using the various means and methods available to him."
	item = /obj/item/storage/fancy/spywatchammobox

	cost = 2
	purchasable_from = UPLINK_NTRAITORS
	category = /datum/uplink_category/ammo

/datum/uplink_item/robomonkey
	name = "'Monkey Do' Radio Controlled Simine Simulant"
	desc = "Leveraging electromechanical \"remote control\" technology, this marvelous piece of equipment lets the agent conduct surveillance or monkey with the stations equipment while still maintaining their cover."

	item = /obj/item/remote_mob_controller/bot/monkey
	cost = 6

	purchasable_from = UPLINK_NTRAITORS
	category = /datum/uplink_category/surverilance

/datum/uplink_item/tracking_stickers
	name = "'Sticky Wicket' Tracking Stickers"
	desc  = "A pack of stickers that each conceal a thin film tracking device.\n\n \
 			Once affixed to an object they allow the agent to track the location of the sticker with a simple crew pinpointer, modified to recieve encrypted NT radio transmissions."

	item = /obj/item/storage/sticker_sheet/tracking
	cost = 2

	purchasable_from = UPLINK_NTRAITORS
	category = /datum/uplink_category/surverilance

/datum/uplink_item/tomahawk
	name = "'Sitting Bull' Tactical Tomahawk"
	desc = "A compact axe of Indian design, updated with new materials fit for the modern battlespace.\n \
			It can be utilzed to tactically dispatch the enemy in hand-to-hand combat  \
			or employed as a throwing weapon in order to neutralize him at some distrance."

	item = /obj/item/hatchet/tomahawk
	cost = 3

	purchasable_from = UPLINK_NTRAITORS
	category = /datum/uplink_category/stealthy

/datum/uplink_item/dazzle_grenade
	name = "Dazzle Grenade"
	desc = "A grenade which upon detonation creates a field with strange optical properties, darkening the surronding area and blinding anyone looking directly at the epicenter."
	cost = 2
	item = /obj/item/grenade/dazzle
	purchasable_from = UPLINK_NTRAITORS
	category = /datum/uplink_category/explosives

/datum/uplink_item/disguise_kit
	name = "Disguise Kit"
	desc = "A small box containing various wigs, fake mustaches and other items to help the agent conceal their identity."

	item = /obj/item/storage/case/disguise
	cost = 3

	purchasable_from = UPLINK_NTRAITORS
	category = /datum/uplink_category/disguise

// STOCK TG ITEMS

/datum/uplink_item/mini_egun
	name = "Minaturized Energy Gun"
	desc = "A small energy gun, designed to be easily concealable in any manner known to the agent. "

	item = /obj/item/gun/energy/e_gun/mini
	cost = 4

	purchasable_from = UPLINK_NTRAITORS
	category = /datum/uplink_category/stealthy

/datum/uplink_item/explosives/c4bag/nt
	name = "Bag of C-4 explosives"
	desc = "Because sometimes quantity is quality. Contains 10 C-4 plastic explosives."
	item = /obj/item/storage/backpack/duffelbag/syndie/nt/c4
	limited_stock = 2
	purchasable_from = UPLINK_NTRAITORS

// NEW ITEM DECLARATIONS: MOVE TO PROPER FILE

/obj/item/storage/case
	name = "wooden box"
	desc = "A fine wooden box. Who knows what little trinkets it could hold?"

	icon = 'icons/obj/storage/donk_storage.dmi'
	icon_state = "wooden_box-m"
	base_icon_state = "wooden_box-m"

	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)
	/// Is the case open or not?
	var/lid_open = FALSE

/obj/item/storage/case/update_icon_state()
	icon_state = "[base_icon_state][lid_open ? "_open" : null]"
	return ..()

/obj/item/storage/case/attack_self(mob/user)
	lid_open = !lid_open
	update_appearance()
	. = ..()

/obj/item/storage/case/disguise

/obj/item/storage/case/disguise/PopulateContents()
	. = ..()
	new /obj/item/clothing/head/wig/short_black(src)
	new /obj/item/clothing/head/wig/long_blonde(src)
	new /obj/item/clothing/head/wig/medium_brown(src)
	new /obj/item/clothing/mask/fakemoustache/biker(src)
	new /obj/item/clothing/mask/fakemoustache/italian(src)
	new /obj/item/clothing/mask/fakemoustache/beard(src)


/obj/item/storage/case/nt_gun
	name = "blue case"
	icon_state =  "nt_case"
	base_icon_state = "nt_case"
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT *2)


/obj/item/storage/case/nt_gun/update_overlays()
	. = ..()
	if(!lid_opem)
		return
	if(locate(/obj/item/gun) in contents)
		var/mutable_appearance/gun_overlay = mutable_appearance(icon, "[base_icon_state]_gun")
		. += gun_overlay
	if(locate(/obj/item/stock_parts/power_store/cell/crap) in contents)
		var/mutable_appearance/alkaline_overlay = mutable_appearance(icon, "[base_icon_state]_cell-alkaline")
		. += alkaline_overlay
	else if(locate(/obj/item/stock_parts/power_store/cell) in contents)
		var/mutable_appearance/lion_overlay = mutable_appearance(icon, "[base_icon_state]_cell-recharge")
		. += lion_overlay

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
	icon = 'icons/mob/human/human_face.dmi'
	icon_state =  "facial_hogan"
	worn_icon = 'icons/mob/human/human_face.dmi'
	worn_icon_state = "facial_hogan"
	color = COLOR_DARK_MODERATE_ORANGE
	SET_BASE_PIXEL(0, -12)

/obj/item/clothing/mask/fakemoustache/beard
	icon = 'icons/mob/human/human_face.dmi'
	icon_state =  "facial_fullbeard"
	worn_icon = 'icons/mob/human/human_face.dmi'
	worn_icon_state = "facial_fullbeard"
	color = COLOR_ALMOST_BLACK
	SET_BASE_PIXEL(0, -12)

/obj/item/storage/backpack/duffelbag/syndie/nt
	name = "nanotrasen nanoduffel™"
	desc = "A large branded duffelbag, emblazoned with the NT logo. A signal of loyalty, or unchecked consumerism?"
	icon = 'icons/obj/storage/donk_storage.dmi'
	icon_state = "duffelbag-nt"
	inhand_icon_state = "duffel-captain"

/obj/item/storage/backpack/duffelbag/syndie/nt/c4/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/grenade/c4(src)


/obj/item/storage/sticker_sheet
	icon = 'icons/obj/storage/donk_storage.dmi'
	icon_state = "sheet"
	/// list of possible offset for each size of sticker. This wont work
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
