/**
 * This is ultra stupid, but essentially androids use robotic limb subtypes that are NOT
 * immune to being replaced on species change.
 * Yes, that is the entire reason these exist.
 */

/obj/item/bodypart/head/robot/android
	change_exempt_flags = NONE

/obj/item/bodypart/chest/robot/android
	change_exempt_flags = NONE

/obj/item/bodypart/arm/left/robot/android
	change_exempt_flags = NONE

/obj/item/bodypart/arm/right/robot/android
	change_exempt_flags = NONE

/obj/item/bodypart/leg/left/robot/android
	change_exempt_flags = NONE

/obj/item/bodypart/leg/right/robot/android
	change_exempt_flags = NONE


///Monkey version of the above



/obj/item/bodypart/head/robot/android/monkey
	name = "robotic monkey head"
	icon = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'
	icon_static = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'

	bodyshape = BODYSHAPE_MONKEY

	change_exempt_flags = NONE

/obj/item/bodypart/chest/robot/android/monkey
	name = "artifical simian chest"
	icon = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'
	icon_static = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'

	bodyshape = BODYSHAPE_MONKEY
	acceptable_bodyshape = BODYSHAPE_MONKEY

	change_exempt_flags = NONE
	bodypart_traits = list(
		TRAIT_PASSTABLE,
		TRAIT_VENTCRAWLER_NUDE,
		TRAIT_NO_AUGMENTS,
		TRAIT_NO_UNDERWEAR,
	)

/obj/item/bodypart/chest/robot/android/monkey/update_mob_heights(mob/living/carbon/holder)
	if(HAS_TRAIT(holder, TRAIT_DWARF))
		return MONKEY_HEIGHT_DWARF

	if(HAS_TRAIT(holder, TRAIT_TOO_TALL))
		return MONKEY_HEIGHT_TALL

	return MONKEY_HEIGHT_MEDIUM


/obj/item/bodypart/arm/left/robot/android/monkey
	name = "left robotic monkey paw"
	icon = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'
	icon_static = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'

	bodyshape = BODYSHAPE_MONKEY
	change_exempt_flags = NONE

/obj/item/bodypart/arm/right/robot/android/monkey
	name = "right robotic monkey paw"
	icon = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'
	icon_static = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'

	bodyshape = BODYSHAPE_MONKEY
	change_exempt_flags = NONE

/obj/item/bodypart/leg/left/robot/android/monkey
	name = "left hydraulic monkey leg"
	icon = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'
	icon_static = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'
	bodyshape = BODYSHAPE_MONKEY
	change_exempt_flags = NONE

/obj/item/bodypart/leg/right/robot/android/monkey
	name = "right hydraulic monkey leg"
	icon = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'
	icon_static = 'icons/mob/human/species/monkey/androidmonkey_bodyparts.dmi'
	bodyshape = BODYSHAPE_MONKEY
	change_exempt_flags = NONE


