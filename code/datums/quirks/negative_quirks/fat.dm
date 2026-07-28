/datum/quirk/fat
	name = "Fat"
	quirk_category = QUIRK_CATEGORY_NEGATIVE
	desc = "You are fat. Some clothing might not fit you, and you are unlikely to outrun your coworkers."
	contract_flavor_text = "Let me first adress the elephant in the room. They are quite obese."
	medical_record_text = "Patient has a history of struggles with their weight."
	icon = FA_ICON_BALANCE_SCALE_RIGHT
	value = -4
	hardcore_value = 5
	quirk_flags = QUIRK_HUMAN_ONLY
	mail_goodies = list(/obj/item/storage/box/donkpockets) // to help eating

/datum/quirk/fat/add(client/client_source)
	quirk_holder.adjust_fat(5000 KILO CALORIES)

/datum/quirk/fat/remove()
	quirk_holder.body_fat_ratio = BODY_FAT_NORMAL
