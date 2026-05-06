/datum/quirk/trust_fund
	name = "Trust Fund"
	quirk_category = QUIRK_CATEGORY_POSITIVE
	desc = "You were born into wealth. You begin the round with an additional 500 credits in your bank account."
	icon = FA_ICON_MONEY_BILL_WAVE
	value = 5
	medical_record_text = "Patient is notably well-off. Lucky them."
	contract_flavor_text = "Subject comes from a background of significant financial privilege. \
		Bank records indicate an above-average starting balance with no clear source of income. \
		Personnel of this type may be motivated by goals other than their paycheck."

/datum/quirk/trust_fund/add_unique(client/client_source)
	. = ..()
	var/obj/item/card/id/id_card = quirk_holder.get_idcard(TRUE)
	if(id_card?.registered_account)
		id_card.registered_account.adjust_money(500, "Trust Fund inheritance")
