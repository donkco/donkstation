/datum/ailment
	var/name = "unknown ailment"
	var/desc = "A heckin' special unicorn disease that not even your doctor knows about."

	/// How severe our disease
	var/staging = AILMENT_MILD
	/// weakref of the ailing mob
	var/datum/weakref/ailing_mob

	/// Any signs that are helpful when diagnosing the patient but that typically dont have any negative effects by themselves.
	//var/list/datum/sign/signs = list()
	/// Aby trauts conferred by our illness
	var/list/illness_traits = list()

/datum/ailment/New(mob/living/afflicted, initial_stage)
	. = ..()
	if(!isliving(afflicted))
		return
	if(initial_stage)
		staging = initial_stage

	ailing_mob = WEAKREF(afflicted)
	aquire()
	/* var/list/new_signs = list()
	for(var/datum/sign/novel_sign in signs)
		novel_signs += new novel_sign(afflicted)
	signs = new_signs */

/datum/ailment/Destroy(force)
	. = ..()
	cure()

/// called then the ailment is first aquired, sets up the initial effects
/datum/ailment/proc/aquire()
	SHOULD_CALL_PARENT(TRUE)
	accute_effects(NONE)
	RegisterSignal(ailing_mob.resolve(), COMSIG_LIVING_LIFE, PROC_REF(on_life))
	return

/// Called when the disease is cured, removes the effects and makes sure the disease deletes itself.
/datum/ailment/proc/cure()
	SHOULD_CALL_PARENT(TRUE)
	var/mob/living/cured_patient = ailing_mob.resolve()
	UnregisterSignal(cured_patient, COMSIG_LIVING_LIFE)
	if(!cured_patient || QDELETED(cured_patient))
		return // We lost him...

	cured_patient.remove_traits(illness_traits, source = src)
	if(!QDELETED(src))
		qdel(src)

/// Decreases disease severity
/datum/ailment/proc/remiss(allow_cure = FALSE)
	switch(staging)
		if(AILMENT_FLARED)
			set_staging(AILMENT_MODERATE) //even if the
			return
		if(AILMENT_SEVERE)
			set_staging(AILMENT_MODERATE)
			return
		if(AILMENT_MODERATE)
			set_staging(AILMENT_MILD)
			return
		if(AILMENT_MILD)
			if(!allow_cure)
				return
			cure()

/// Increases illness severity
/datum/ailment/proc/progress()
	switch(staging)
		if(AILMENT_DORMANT)
			set_staging(AILMENT_MILD)
			return
		if(AILMENT_MILD)
			set_staging(AILMENT_MODERATE)
			return
		if(AILMENT_MODERATE)
			set_staging(AILMENT_SEVERE)
			return

/// Handles continous effects of the ailment tied to the mobs life tick
/datum/ailment/proc/on_life(seconds_per_tick)
	SIGNAL_HANDLER
	return

/datum/ailment/proc/set_staging(new_staging)
		var/previous_stage = staging
		staging = new_staging
		accute_effects(previous_stage)
		SEND_SIGNAL(src, AILMENT_STAGE_CHANGED, previous_stage)

/datum/ailment/proc/accute_effects(previous_stage)
	return

/datum/ailment/proc/get_diagnosis(mob/examining_physician)
	var/qualified_name
	switch(staging)
		if(0 to AILMENT_MILD)
			qualified_name = "mild [name]"
		if(AILMENT_SEVERE to INFINITY)
			qualified_name = "severe[name]"
		else
			qualified_name = name

	var/diagnostic_aptitude = examining_physician?.mind?.get_skill_level(/datum/skill/medicine)
	if(!diagnostic_aptitude) //probably some unthinking mindless entity
		return span_notice("diagnosis found: [qualified_name]")

	var/self_diagnosis = examining_physician == ailing_mob.resolve()
	if(diagnostic_aptitude == SKILL_LEVEL_BAD)
		return span_warning(self_diagnosis ? "I don't feel so good." : "They don't look so good.")
	if(diagnostic_aptitude <= SKILL_LEVEL_HORRIBLE)
		return span_warning(self_diagnosis ? "Some witch cast a spell on me..." : "The patient is possesed by demonic spirits.")

	return span_notice(self_diagnosis ? "I have [qualified_name]." : "The patient is suffering from [qualified_name].")


/datum/ailment/obesitas
	name = "obesity"
	desc = "A metabolic disorder characterized by massive subdermal lipid accumulation. \
		It is thought to be aquired as the result of chronic overeating and lack impulse control on account of the patient. \
		The role of affordable, nutrient dense and delicously prepared snack-foods is uncertain and studies have yielded conflicting results."
	illness_traits = list(TRAIT_OFF_BALANCE_TACKLER)

/datum/ailment/obesitas/on_life(mob/living/chonker, seconds_per_tick)
	if((chonker?.body_fat_ratio || 0) <= BODY_FAT_NORMAL) // No mob, no fat or no fat mob
		cure()
		return

	switch(chonker.body_fat_ratio)

		if(0 to BODY_FAT_NORMAL)
			remiss(TRUE)
			return

		if(BODY_FAT_NORMAL to BODY_FAT_OVERWEIGHT)

			if(staging > AILMENT_MILD)
				remiss()

		if(BODY_FAT_OVERWEIGHT to BODY_FAT_OBESE)

			if(staging < AILMENT_MILD)
				progress()

		if(BODY_FAT_OBESE to INFINITY)
			progress()

/datum/ailment/obesitas/accute_effects(previous_stage)
	. = ..()
	var/mob/living/chonker = ailing_mob.resolve()
	if(staging >= AILMENT_MODERATE && previous_stage < AILMENT_MODERATE)
		SEND_SIGNAL(chonker, COMSIG_MOB_BECAME_OBESE)
		illness_traits += TRAIT_VORACIOUS
		ADD_TRAIT(chonker, TRAIT_VORACIOUS, src)
		to_chat(chonker, span_alertwarning("You suddenly feel blubbery!"))

	chonker.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/fat, staging ** 2 * 0.05)

/datum/ailment/obesitas/aquire()
	. = ..()
	var/mob/living/chonker = ailing_mob.resolve()
	//register signals
	RegisterSignal(chonker, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_patient_examination)) // Should maybe be moved to the base class when needed.

/datum/ailment/obesitas/cure()
	var/mob/living/slimmed_mob = ailing_mob.resolve()
	if(!slimmed_mob)
		return ..()

	slimmed_mob.remove_movespeed_modifier(/datum/movespeed_modifier/fat)
	SEND_SIGNAL(slimmed_mob, COMSIG_MOB_SLIMMED_DOWN)
	to_chat(slimmed_mob, span_nicegreen("You feel like you have lost some weight!"))
	//unregister signals
	UnregisterSignal(slimmed_mob, COMSIG_ATOM_EXAMINE_MORE)

	return ..()

/datum/ailment/obesitas/get_diagnosis(mob/examining_physician)
	var/diagnostic_aptitude = examining_physician?.mind?.get_skill_level(/datum/skill/medicine)
	if(!diagnostic_aptitude) //probably some unthinking mindless entity
		return ..()
	var/self_diagnosis = examining_physician == ailing_mob.resolve()
	var/diagnosis = "?"
	switch(diagnostic_aptitude)
		if(SKILL_LEVEL_HORRIBLE)
			diagnosis = self_diagnosis ? "I am just big boned." : "They just have big bones."
			return span_nicegreen(diagnosis)
		if(SKILL_LEVEL_BAD)
			diagnosis = self_diagnosis ? "I am a bit swollen." : "They are experiencing some swelling."
			return span_notice(diagnosis)
		if(SKILL_LEVEL_NORMAL)
			if(staging <= AILMENT_MILD)
				diagnosis = self_diagnosis ? "My weight seems normal." : "They look a bit overweight."
				return span_notice(diagnosis)
			if(staging in AILMENT_MODERATE to AILMENT_SEVERE)
				diagnosis = self_diagnosis ? span_notice("I am a bit overweight.") : span_warning("They are fat.")
				return diagnosis
			if(staging >= AILMENT_SEVERE)
				diagnosis = self_diagnosis ? "I am a pretty fat." : "They are really fat!"
				return span_warning(diagnosis)
		else // Doctor Now mode engage
			if(staging <= AILMENT_MILD)
				diagnosis = self_diagnosis ? "I am a bit above my ideal weight." : "The patient is overweight."
				return span_notice(diagnosis)
			if(staging == AILMENT_MODERATE)
				diagnosis = self_diagnosis ? "I am obese." : "The patient is suffering from obesitas."
				return span_notice(diagnosis)
			if(staging == AILMENT_SEVERE)
				diagnosis = self_diagnosis ? "I am obese." : "The patient is suffering from morbid obesity."
				return span_notice(diagnosis)
			if(staging > AILMENT_SEVERE)
				diagnosis = self_diagnosis ? "I am a decidedly obese." : "The patient is suffering from a rare and striking case of extremely aggravated obesitas."
				return span_warning(diagnosis)
	return ..()

/datum/ailment/obesitas/proc/on_patient_examination(patient, mob/examiner, list/examine_list)
	SIGNAL_HANDLER
	examine_list += get_diagnosis(examiner)

/datum/movespeed_modifier/fat
	variable = TRUE
	multiplicative_slowdown = 0.4
	blacklisted_movetypes = FLOATING | FLYING
