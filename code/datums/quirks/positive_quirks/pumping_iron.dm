/datum/quirk/pumping_iron
	name = "Pumping Iron"
	quirk_category = QUIRK_CATEGORY_POSITIVE
	desc = "You have a strong physique! You start with a higher level of athletics and are generally stronger than the average person."
	value = 2
	mob_trait = TRAIT_PUMPING_IRON
	medical_record_text = "Patient has a strong physique."

/datum/quirk/pumping_iron/add_unique(client/client_source)
	. = ..()
	quirk_holder.mind?.set_level(/datum/skill/athletics, SKILL_LEVEL_EXPERT, TRUE)
