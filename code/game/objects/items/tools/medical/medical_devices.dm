/obj/item/blood_tester
	name = "HemaLyze™ blood tester"
	desc = "A clinical device used to draw and analyze blood."

	icon = 'icons/obj/medical/medical_devices.dmi'
	icon_state = "blood_tester"

	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT, /datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT / 2, /datum/material/lead = HALF_SHEET_MATERIAL_AMOUNT / 2)

/obj/item/blood_tester/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	to_chat(user, span_notice("Blood parameters:\n\
							---------------------------------------"))

	if(!(target_mob.mob_biotypes & MOB_ORGANIC))
		to_chat(user, span_warning("ERROR: Patient contains no viable fluids for analysis."))
		return

	// Blood sugar / nutrition : Expressed as mg/dl rather than nmol/ml because the former was easier to calculate.
	to_chat(user, span_notice("Glucose: [round(target_mob.nutrition / JOULES_PER_BLOOD_GLUCOSE)] mg/dl"))

	// Body fat
	switch(target_mob.body_fat_ratio)
		if(NONE to BODY_FAT_DANGER)
			to_chat(user, span_boldwarning("Free lipids: N/D \[ ! \]"))
		if(BODY_FAT_DANGER to BODY_FAT_NORMAL)
			to_chat(user, span_notice("Free lipids: Low"))
		if(BODY_FAT_NORMAL to BODY_FAT_OVERWEIGHT)
			to_chat(user, span_nicegreen("Free lipids: Nominal"))
		if(BODY_FAT_OVERWEIGHT to BODY_FAT_OBESE)
			to_chat(user, span_notice("Free lipids: Elevated"))
		if(BODY_FAT_OBESE to BODY_FAT_EXTREMELY_OBESE)
			to_chat(user, span_cautiousyellow("Free lipids: High \[ ! \]"))
		if(BODY_FAT_EXTREMELY_OBESE to INFINITY)
			to_chat(user, span_hotdog("Free lipids: Extremely High \[ ! \]"))

	// Oxy loss
	switch(round(target_mob.get_oxy_loss()))
		if(NONE to 10)
			to_chat(user, span_nicegreen("Oxygen saturation: Nominal"))
		if(11 to 25)
			to_chat(user, span_cautiousyellow("Oxygen saturation: Low \[ ! \]"))
		if(26 to 50)
			to_chat(user, span_warning("Oxygen saturation: Danger \[ ! \]"))
		if(51 to 185)
			to_chat(user, span_hotdog("Oxygen saturation: Critical \[ ! \]"))
		if(186 to INFINITY)
			to_chat(user, span_boldwarning("Oxygen saturation: N/D \[ ! \]"))

	// Blood type
	to_chat(user,span_notice("Blood_type: [target_mob.get_bloodtype()?.name || "ERR"]"))

	to_chat(user, span_notice("---------------------------------------\n\
							Thank you for using the DeForest HemaLyze™ System!\n\
							For more insights, subscribe to DeForest HemaLyze Insights™ today!"))
	playsound(src, 'sound/items/barcodebeep.ogg', 25)

