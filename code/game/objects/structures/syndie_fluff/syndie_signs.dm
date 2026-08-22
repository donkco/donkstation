/obj/structure/sign/neon
	name = "suspicious sign"
	desc = "Any successful business needs a nice sign. Megacorporations are no different."

	icon = 'icons/obj/fluff/syndicate/syndie_fluff.dmi'
	icon_state = "sign-sus"

	SET_BASE_PIXEL(0, 30)

/obj/structure/sign/neon/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/structure/sign/neon/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "[icon_state]_emissive", src)

/obj/structure/sign/neon/jolly

	icon_state = "sign-jolly"

/obj/structure/sign/neon/jolly/red

	icon_state = "sign-jolly-red"

/obj/structure/sign/neon/snakes

	icon_state = "sign-snakes"

/obj/structure/sign/banner
	name = "wall banner"
	desc = "I've always appreciated the textile arts."

	icon = 'icons/obj/fluff/syndicate/syndie_fluff.dmi'
	icon_state = "banner-serpent"

	custom_materials = list(/datum/material/plastic = 2 * SHEET_MATERIAL_AMOUNT) // No cloth material yet sadge

	SET_BASE_PIXEL(0, 30)

/obj/structure/sign/banner/jolly
	name = "jolly roger"
	icon_state = "jolly_roger"

/obj/structure/sign/banner/jolly/red
	name = "blood-red jolly roger"
	icon_state = "jolly_roger-red_flag_of_revenge"

/obj/structure/sign/calendar/sus
	name = "racy charity calendar"
	desc = "An interesting calendar raising money for the security officer benevolence society. You suddenly feel a bit more supportive of our brave first responders."

	icon = 'icons/obj/donk_structures/donk_wallmounts.dmi'
	icon_state = "suspicious_calendar"

	custom_materials = list(/datum/material/paper = 2 * SHEET_MATERIAL_AMOUNT)

	SET_BASE_PIXEL(0, 30)

/obj/structure/sign/coder_painting
	name = "portrait of an ape"
	desc = "An oil painting depicting the face of a monkey. The monkey has a primal yet mischevious expression on its face."

	icon = 'icons/obj/donk_structures/donk_wallmounts.dmi'
	icon_state = "monkey_painting"

	custom_materials = list(/datum/material/wood = 3 * SHEET_MATERIAL_AMOUNT)

	SET_BASE_PIXEL(0, 30)
