
//----------------------- FANCY CHAIRS ----------------------------------------------

/obj/structure/chair/office/orange
	name ="donk co office chair"
	desc = "A bright and soft chair. It welcomes you to sit down and create shareholder value!"
	icon = 'icons/obj/donk_furniture/donkchairs.dmi'
	icon_state = "office_orange"

/obj/structure/chair/office/executive
	name ="executive business chair"
	desc = "Many people are saying that sitting in this chair is like being cradled by the invisible hands of the free market itself!\n\nA must have for the modern, forward-thinking businessman."

	icon = 'icons/obj/donk_furniture/donkchairs_tall.dmi'
	icon_state = "executive"

	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT, /datum/material/wood = SHEET_MATERIAL_AMOUNT)
	buildstacktype = /obj/item/stack/sheet/leather
	buildstackamount = 4

/obj/structure/chair/cane
	name = "rattan chair"
	desc = "A stylish chair utilizing exotic cane-based materials from the mysterious Terran orient."

	icon = 'icons/obj/donk_furniture/donkchairs.dmi'
	icon_state = "cane"

	custom_materials = list(/datum/material/bamboo = SHEET_MATERIAL_AMOUNT, /datum/material/wood = SHEET_MATERIAL_AMOUNT)
	buildstacktype = /obj/item/stack/sheet/mineral/bamboo

	item_chair = null

/obj/structure/chair/bean
	name = "beanbag chair"
	desc = "Cutting edge granular matter technology is leveraged to allow this device to instantly conform to the users body!"

	icon = 'icons/obj/donk_furniture/donkchairs.dmi'
	icon_state = "bean_red"

	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 3)
	buildstacktype = /obj/item/stack/sheet/plastic
	buildstackamount = 3

	item_chair = null
// ---------------------- LOUNGE CHAIRS ----------------------------------------------
// Available in various upholstery colours, inquire for more colour options if desired.
//
// Maybe new types of wood or synthetic materials for frames could be explored beyond
// chocolatey teak and light birch.
// ------------------------------------------------------------------------------------
/obj/structure/chair/lounger
	name = "lounge chair"

	icon = 'icons/obj/donk_furniture/donkchairs.dmi'
	icon_state = "lounger_bone"

	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)
	buildstacktype = /obj/item/stack/sheet/leather

	item_chair = null

/obj/structure/chair/lounger/bone

/obj/structure/chair/lounger/mustard
	icon_state = "lounger_mustard"

/obj/structure/chair/avocado
	icon_state = "lounger_avocado"

/obj/structure/chair/livid
	icon_state = "lounger_livid"

/obj/structure/chair/lounger/laidback
	icon_state = "laidback_bone"

/obj/structure/chair/lounger/laidback/bone

/obj/structure/chair/lounger/laidback/sus
	name = "suspicious lounge chair"
	desc = "Like the members of the syndicate, the individual legs work together to achieve great strength and stability. Wow!"

	icon_state = "laidback_sus"

/obj/structure/chair/lounger/laidback/red
	icon_state = "laidback_red"

/obj/structure/chair/lounger/laidback/mustard
	icon_state = "laidback_mustard"

/obj/structure/chair/lounger/laidback/avocado
	icon_state = "laidback_avocado"

/obj/structure/chair/lounger/laidback/teal
	icon_state = "laidback_teal"

/obj/structure/chair/lounger/laidback/livid
	icon_state = "laidback_livid"

/obj/structure/chair/lounger/laidback/azure
	icon_state = "laidback_azure"

