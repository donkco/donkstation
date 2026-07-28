/datum/surgery_operation/limb/lipoplasty
	name = "excise excess fat"
	rnd_name = "Lipoplasty (Excise Fat)"
	desc = "Remove excess fat from a patient's body."
	operation_flags = OPERATION_NOTABLE | OPERATION_AFFECTS_MOOD
	implements = list(
		TOOL_SAW = 1,
		TOOL_SCALPEL = 1.25,
		/obj/item/shovel/serrated = 1.33,
		/obj/item/melee/energy/sword = 1.33,
		/obj/item/hatchet = 3.33,
		/obj/item/knife = 3.33,
		/obj/item = 5,
	)
	time = 6.4 SECONDS
	required_bodytype = ~BODYTYPE_ROBOTIC
	preop_sound = list(
		/obj/item/circular_saw = 'sound/items/handling/surgery/saw.ogg',
		/obj/item = 'sound/items/handling/surgery/scalpel1.ogg',
	)
	success_sound = 'sound/items/handling/surgery/organ2.ogg'
	all_surgery_states_required = SURGERY_SKIN_OPEN
	any_surgery_states_blocked = SURGERY_VESSELS_UNCLAMPED

/datum/surgery_operation/limb/lipoplasty/get_any_tool()
	return "Any sharp edged item"

/datum/surgery_operation/limb/lipoplasty/get_default_radial_image()
	return image(/obj/item/food/meat/slab/human)

/datum/surgery_operation/limb/lipoplasty/all_required_strings()
	. = list()
	. += "operate on chest (target chest)"
	. += ..()
	. += "the patient must have excess fat to remove"

/datum/surgery_operation/limb/lipoplasty/tool_check(obj/item/tool)
	// Require edged sharpness OR a tool behavior match
	return ((tool.get_sharpness() & SHARP_EDGED) || implements[tool.tool_behaviour])

/datum/surgery_operation/limb/lipoplasty/state_check(obj/item/bodypart/limb)
	if(limb.body_zone != BODY_ZONE_CHEST)
		return FALSE
	if(HAS_TRAIT(limb.owner, TRAIT_NOHUNGER))
		return FALSE
	if(!HAS_TRAIT_FROM(limb.owner, TRAIT_FAT, OBESITY) || limb.owner.nutrition < NUTRITION_LEVEL_WELL_FED)
		return FALSE
	return TRUE

/datum/surgery_operation/limb/lipoplasty/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin to cut away [limb.owner]'s excess fat..."),
		span_notice("[surgeon] begins to cut away [limb.owner]'s excess fat."),
		span_notice("[surgeon] begins to cut [limb.owner]'s [limb.plaintext_zone] with [tool]."),
	)
	display_pain(limb.owner, "You feel a stabbing in your [limb.plaintext_zone]!")

/datum/surgery_operation/limb/lipoplasty/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You successfully remove excess fat from [limb.owner]'s body!"),
		span_notice("[surgeon] successfully removes excess fat from [limb.owner]'s body!"),
		span_notice("[surgeon] finishes cutting away excess fat from [limb.owner]'s [limb.plaintext_zone]."),
	)
	var/removed_fat = limb.owner.body_fat_ratio - BODY_FAT_NORMAL
	limb.owner.body_fat_ratio = BODY_FAT_NORMAL

	if(limb.owner.flags_1 & HOLOGRAM_1)
		return


	for(var/i in round(removed_fat / 255 * ENERGY_DENSITY_FAT))
		new /obj/item/food/fat/human(limb.owner.drop_location())

/obj/item/food/fat
	name = "fatty glob"
	desc = "A glob of wobbly fatty fat. "

	icon = 'icons/obj/food/donk_ingredients.dmi'
	icon_state = "fatty_tissue"

	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 50,
		/datum/reagent/consumable/nutriment/fat = 200,
		/datum/reagent/consumable/nutriment/vitamin = 5,)
	tastes = list("fat" = 1)
	foodtypes = MEAT | RAW

/obj/item/food/fat/human

/obj/item/food/fat/human/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/lore, string_list_of_assoc_lists(list( \
		list( \
			"skill" = /datum/skill/medicine, \
			"min_level" = SKILL_LEVEL_JOURNEYMAN, \
			"article" = "a", \
			"name " = "piece of adipose tissue", \
			"desc" = "A sample of human adipose tissue, or fat, taken from a patient.", \
		),
		list( \
			"skill" = /datum/skill/medicine, \
			"min_level" = SKILL_LEVEL_LEGENDARY, \
			"article" = "", \
			"name " = "axungia hominis", \
			"desc" = "Axungia hominis; the fat of man. A pox on its bearer, yet a substance of great potential when separated from its host.", \
		))), show_only_on_examine_more = FALSE)

/datum/surgery_operation/limb/lipoplasty/mechanic
	name = "engage expulsion valve" //gross
	rnd_name = "Nutrient Reserve Expulsion (Excise Fat)"
	implements = list(
		TOOL_WRENCH = 1.05,
		TOOL_CROWBAR = 1.05,
		/obj/item/shovel/serrated = 1.33,
		/obj/item/melee/energy/sword = 1.33,
		TOOL_SAW = 1.67,
		/obj/item/hatchet = 3.33,
		/obj/item/knife = 3.33,
		TOOL_SCALPEL = 4,
		/obj/item = 5,
	)
	preop_sound = 'sound/items/tools/ratchet.ogg'
	success_sound = 'sound/items/handling/surgery/organ2.ogg'
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC
