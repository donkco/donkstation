/proc/generate_underwear_icon(datum/sprite_accessory/accessory, datum/universal_icon/base_icon, color)
	var/datum/universal_icon/final_icon = base_icon.copy()

	if (!isnull(accessory))
		var/datum/universal_icon/accessory_icon = uni_icon('icons/mob/clothing/underwear.dmi', accessory.icon_state)
		if (color && !accessory.use_static)
			accessory_icon.blend_color(color, ICON_MULTIPLY)
		final_icon.blend_icon(accessory_icon, ICON_OVERLAY)

	final_icon.crop(10, 1, 22, 13)
	final_icon.scale(32, 32)

	return final_icon

/// Backpack preference
/datum/preference/choiced/backpack
	savefile_key = "backpack"
	savefile_identifier = PREFERENCE_CHARACTER
	main_feature_name = "Backpack"
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE

/datum/preference/choiced/backpack/init_possible_values()
	return list(
		GBACKPACK,
		GSATCHEL,
		LSATCHEL,
		GDUFFELBAG,
		GMESSENGER,
		DBACKPACK,
		DSATCHEL,
		DDUFFELBAG,
		DMESSENGER,
	)

/datum/preference/choiced/backpack/create_default_value()
	return DBACKPACK

/datum/preference/choiced/backpack/icon_for(value)
	switch (value)
		if (GBACKPACK)
			return /obj/item/storage/backpack
		if (GSATCHEL)
			return /obj/item/storage/backpack/satchel
		if (LSATCHEL)
			return /obj/item/storage/backpack/satchel/leather
		if (GDUFFELBAG)
			return /obj/item/storage/backpack/duffelbag
		if (GMESSENGER)
			return /obj/item/storage/backpack/messenger

		// In a perfect world, these would be your department's backpack.
		// However, this doesn't factor in assistants, or no high slot, and would
		// also increase the spritesheet size a lot.
		// I play medical doctor, and so medical doctor you get.
		if (DBACKPACK)
			return /obj/item/storage/backpack/medic
		if (DSATCHEL)
			return /obj/item/storage/backpack/satchel/med
		if (DDUFFELBAG)
			return /obj/item/storage/backpack/duffelbag/med
		if (DMESSENGER)
			return /obj/item/storage/backpack/messenger/med

/datum/preference/choiced/backpack/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.backpack = value

/// Jumpsuit preference
/datum/preference/choiced/jumpsuit
	savefile_key = "jumpsuit_style"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODY_TYPE
	main_feature_name = "Jumpsuit"
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE

/datum/preference/choiced/jumpsuit/init_possible_values()
	return list(
		PREF_SUIT,
		PREF_SKIRT,
	)

/datum/preference/choiced/jumpsuit/create_default_value()
	return PREF_SUIT

/datum/preference/choiced/jumpsuit/icon_for(value)
	switch (value)
		if (PREF_SUIT)
			return /obj/item/clothing/under/color/grey
		if (PREF_SKIRT)
			return /obj/item/clothing/under/color/jumpskirt/grey

/datum/preference/choiced/jumpsuit/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.jumpsuit_style = value

