/obj/item/card/donk_loyalty
	name = "Donk Co. Club Loyalty Rewards Card"
	desc = "A shiny gold loyalty rewards card from Donk Co. Swipe it at a vending machine to receive a 25% discount on your next purchase. Must be swiped before each purchase."
	icon_state = "card_gold"
	w_class = WEIGHT_CLASS_TINY

/datum/quirk/item_quirk/donk_club
	name = "Donk Co. Club Member"
	quirk_category = QUIRK_CATEGORY_POSITIVE
	desc = "You're a proud member of the Donk Co. Club Loyalty Rewards Program! You start with a loyalty card that grants you a 25% discount at vending machines. You must swipe it before each purchase."
	icon = FA_ICON_ID_CARD
	value = 3
	medical_record_text = "Patient carries a Donk Co. Club Loyalty Rewards Card. Not sure how this is medically relevant...Who put this on here?"
	contract_flavor_text = "Hire is enrolled in the Donk Co. Club Loyalty Rewards Program — a suspiciously exclusive membership for a snack food brand. \
		The card in their possession appears to be legitimate. How they obtained it is unclear."
	mail_goodies = list(/obj/item/food/donkpocket)

/datum/quirk/item_quirk/donk_club/add_unique(client/client_source)
	. = ..()
	give_item_to_holder(/obj/item/card/donk_loyalty, list(LOCATION_BACKPACK, LOCATION_HANDS))
