
/**
 * # Power cell
 *
 * Power cells, used primarily for handheld and portable things. Holds a reasonable amount of power.
 */
/obj/item/stock_parts/power_store/cell
	name = "power cell"
	desc = "A rechargeable electrochemical power cell."
	icon = 'icons/obj/machines/cell_charger.dmi'
	icon_state = "cell"
	inhand_icon_state = "cell"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	force = 5
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	emp_damage_modifier = 1
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*7, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.5)

/obj/item/stock_parts/power_store/cell/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_FISHING_BAIT, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_POISONOUS_BAIT, INNATE_TRAIT) //bro is fishing using lithium...
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/battery_match)
	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/stock_parts/power_store/cell/grind_results()
	return list(/datum/reagent/lithium = 15, /datum/reagent/iron = 5, /datum/reagent/silicon = 5)

/* Stock TG cells */

/obj/item/stock_parts/power_store/cell/empty
	empty = TRUE

/obj/item/stock_parts/power_store/cell/bluespace/tactical
	name = "tactical bluespace cell"
	emp_damage_modifier = 0.5
	chargerate = STANDARD_CELL_RATE * 0.75

/obj/item/stock_parts/power_store/cell/high
	name = "high-capacity power cell"
	icon_state = "hcell"
	emp_damage_modifier = 3
	maxcharge = STANDARD_CELL_CHARGE * 10
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 0.7, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.6)
	chargerate = STANDARD_CELL_RATE * 0.75

/obj/item/stock_parts/power_store/cell/high/empty
	empty = TRUE

/obj/item/stock_parts/power_store/cell/super
	name = "super-capacity power cell"
	icon_state = "scell"
	emp_damage_modifier = 5
	maxcharge = STANDARD_CELL_CHARGE * 20
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 0.7, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.7)
	chargerate = STANDARD_CELL_RATE

/obj/item/stock_parts/power_store/cell/super/empty
	empty = TRUE

/obj/item/stock_parts/power_store/cell/hyper
	name = "hyper-capacity power cell"
	icon_state = "hpcell"
	emp_damage_modifier = 5
	maxcharge = STANDARD_CELL_CHARGE * 30
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 0.7, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 1.5, /datum/material/silver = SMALL_MATERIAL_AMOUNT * 1.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.8)
	chargerate = STANDARD_CELL_RATE * 1.5

/obj/item/stock_parts/power_store/cell/hyper/empty
	empty = TRUE

/obj/item/stock_parts/power_store/cell/bluespace
	name = "bluespace power cell"
	desc = "A rechargeable transdimensional power cell."
	icon_state = "bscell"
	emp_damage_modifier = 5
	maxcharge = BLUESPACE_CELL_CHARGE
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 8, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 1.2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.6, /datum/material/diamond = SMALL_MATERIAL_AMOUNT * 1.6, /datum/material/titanium =SMALL_MATERIAL_AMOUNT * 3, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT)
	chargerate = BLUESPACE_CELL_CHARGE * 0.05

/obj/item/stock_parts/power_store/cell/bluespace/empty
	empty = TRUE

/obj/item/stock_parts/power_store/cell/button
	name = "button cell"
	desc = "A tiny silvery disk; a small mote of energy in a sea of entropy."

	icon = 'icons/obj/donk_parts.dmi'
	icon_state = "cell-button"
	base_icon_state = "cell-button"
	charge_light_type = null

	maxcharge = BUTTON_CELL_CHARGE
	chargerate = BUTTON_CELL_CHARGE * 0.15

	w_class = WEIGHT_CLASS_TINY
	cell_size = CELL_SIZE_AA

	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.2, /datum/material/silver = SMALL_MATERIAL_AMOUNT*0.5)

/obj/item/stock_parts/power_store/cell/button/emergency_light
	desc = "A tiny power cell with a very low power capacity. Used in light fixtures to power them in the event of an outage."

/obj/item/stock_parts/power_store/cell/button/emergency_light/Initialize(mapload)
	. = ..()
	var/area/area = get_area(src)
	if(area)
		if(!area.lightswitch || !area.light_power)
			charge = 0 //For naturally depowered areas, we start with no power

/obj/item/stock_parts/power_store/cell/potato
	name = "potato battery"
	desc = "A rechargeable starch based power cell."
	icon = 'icons/obj/service/hydroponics/harvest.dmi'
	icon_state = "potato"
	maxcharge = STANDARD_CELL_CHARGE * 0.3
	emp_damage_modifier = 0.5 //It's biological, so
	charge_light_type = null
	connector_type = null
	custom_materials = null
	grown_battery = TRUE //it has the overlays for wires
	custom_premium_price = PAYCHECK_CREW

/obj/item/stock_parts/power_store/cell/potato/Initialize(mapload, override_maxcharge)
	charge = maxcharge * 0.3
	. = ..()

/obj/item/stock_parts/power_store/cell/aaa
	name = "suspicious AAA cell"
	desc = "Syndicate batteries make sus times last longer."

	icon = 'icons/obj/donk_parts.dmi'
	icon_state = "cell-aaa"
	base_icon_state = "cell-aaa"
	tiny_state ="cell-aaa_tiny"
	charge_light_type = null

	maxcharge = AAA_CELL_CHARGE
	chargerate = AAA_CELL_CHARGE * 0.1

	w_class = WEIGHT_CLASS_TINY
	cell_size = CELL_SIZE_AAA

/obj/item/stock_parts/power_store/cell/aa
	name = "\improper Nanotrasen brand rechargable AA cell"
	desc = "You can't top the plasma top." //TOTALLY COPYRIGHT INFRINGEMENT
	icon = 'icons/obj/donk_parts.dmi'
	icon_state = "cell-aa"
	base_icon_state = "cell-aa"
	charge_light_type = null

	maxcharge = AA_CELL_CHARGE
	chargerate = AA_CELL_CHARGE * 0.05
	cell_size = CELL_SIZE_AA

/obj/item/stock_parts/power_store/cell/aa/lying
	icon_state = "cell-aa-lying"

/obj/item/stock_parts/power_store/cell/aa/fast_charge
	name = "\improper Nanotrasen enviroloop AA cell"
	desc = "A fast charging premium battery, with sticker price that still seems too high when all the great marketing claims are considered."
	icon_state = "cell-aa-loop"
	base_icon_state = "cell-aa-loop"
	tiny_state = "cell-aa-loop_tiny"
	chargerate = AA_CELL_CHARGE * 0.2

/obj/item/stock_parts/power_store/cell/aa/alkaline
	name = "\improper Nanotrasen brand alkaline AA cell"
	icon_state = "cell-aa-alkaline"
	base_icon_state = "cell-aa-alkaline"
	tiny_state = "cell-aa-alkaline_tiny"
	chargerate = 0 //cant be recharged

/obj/item/stock_parts/power_store/cell/aa/alkaline/lying
	icon_state = "cell-aa-lying"

/obj/item/stock_parts/power_store/cell/nine_volt
	name = "9v power cell"
	desc = "A proper cell with some proper voltage!"
	icon_state = "9v_cell"
	charge_light_type = null
	maxcharge = NINE_VOLT_CHARGE
	chargerate = NINE_VOLT_CHARGE * 0.05

	cell_size = CELL_SIZE_NINE_VOLT

/obj/item/stock_parts/power_store/cell/nine_volt/tactical
	name = "tactical 9v cell"
	desc = "A shielded 9v battery, useful if your house is ignited by a nuclear explosion!"
	chargerate = NINE_VOLT_CHARGE * 0.10
	emp_damage_modifier = 0.5

/obj/item/stock_parts/power_store/cell/d
	name = "big D cell"
	desc = "A large, hefty battery."

	icon = 'icons/obj/donk_parts.dmi'
	icon_state = "cell-d"
	base_icon_state = "cell-d"
	charge_light_type = null
	tiny_state = "cell-d_tiny"

	maxcharge = D_CELL_CHARGE
	chargerate = D_CELL_CHARGE * 0.05

	cell_size = CELL_SIZE_D

/obj/item/stock_parts/power_store/cell/ba5800
	name = "gorlex military cell"
	desc = "A powerful thionyl chloride battery, typically restricted to military applications because of the hazardous nature the liquid inside."

	icon = 'icons/obj/donk_parts.dmi'
	icon_state ="cell-ba5800"
	base_icon_state = "cell-ba5800"
	cell_size_prefix = "ba5800"
	charge_light_type = "red"

	maxcharge = BA5800_CELL_CHARGE
	chargerate = BA5800_CELL_CHARGE * 0.15

	cell_size = CELL_SIZE_BA5800

/obj/item/stock_parts/power_store/cell/ba5800/grind_results()
	return list(/datum/reagent/lithium = 20, /datum/reagent/sulfur = 5, /datum/reagent/chlorine = 5, /datum/reagent/oxygen = 10) //Maybe add actual thionyl chlorde here, it is an interesting material.

/obj/item/stock_parts/power_store/cell/ba5800/tactical
	name = "tactical military cell"
	desc = "A powerful thionyl chloride battery. This one is outfitted with extra shielding for special operations."

	base_icon_state = "cell-ba5800-tactical"
	cell_size_prefix = "ba5800"
	charge_light_type = "teal"

	emp_damage_modifier = 0.5

/obj/item/stock_parts/power_store/cell/tool_pack
	name = "power tool battery"
	desc = "Any builder appreciates a nice brick."

	icon = 'icons/obj/donk_parts.dmi'
	icon_state ="cell-toolpack"
	base_icon_state = "cell-toolpack"
	cell_size_prefix = "tool_pack"
	charge_light_type = "teal"

	maxcharge = TOOL_PACK_CHARGE
	chargerate = TOOL_PACK_CHARGE * 0.03
	cell_size = CELL_SIZE_TOOL
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/plastic = SHEET_MATERIAL_AMOUNT)

// -------------- SPECIAL BATTERIES ---------------------------

/obj/item/stock_parts/power_store/cell/ninja
	name = "black power cell"
	icon_state = "bscell"
	emp_damage_modifier = 3
	maxcharge = STANDARD_CELL_CHARGE * 10
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT*0.6)
	chargerate = STANDARD_CELL_RATE

/obj/item/stock_parts/power_store/cell/emproof
	name = "\improper EMP-proof cell"
	desc = "An EMP-proof cell."
	emp_damage_modifier = 0
	maxcharge = STANDARD_CELL_CHARGE * 0.5

/obj/item/stock_parts/power_store/cell/emproof/Initialize(mapload)
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF)
	return ..()

/obj/item/stock_parts/power_store/cell/emproof/empty
	empty = TRUE

/obj/item/stock_parts/power_store/cell/emproof/corrupt()
	return

/obj/item/stock_parts/power_store/cell/emproof/slime
	name = "EMP-proof slime core"
	desc = "A yellow slime core infused with plasma. Its organic nature makes it immune to EMPs."
	icon = 'icons/mob/simple/slimes.dmi'
	icon_state = "yellow-core"
	custom_materials = null
	maxcharge = STANDARD_CELL_CHARGE * 5
	charge_light_type = null
	connector_type = "slimecore"

/obj/item/stock_parts/power_store/cell/crystal_cell
	name = "crystal power cell"
	desc = "A very high power cell made from crystallized plasma"
	icon_state = "crystal_cell"
	maxcharge = STANDARD_CELL_CHARGE * 50
	chargerate = 0
	charge_light_type = null
	connector_type = "crystal"
	custom_materials = null

/obj/item/stock_parts/power_store/cell/crystal_cell/grind_results()
	return null

/obj/item/stock_parts/power_store/cell/infinite
	name = "infinite-capacity power cell"
	icon_state = "icell"
	emp_damage_modifier = 0
	maxcharge = INFINITY //little disappointing if you examine it and it's not huge
	custom_materials = list(/datum/material/glass=HALF_SHEET_MATERIAL_AMOUNT)
	chargerate = INFINITY
	ratingdesc = FALSE

/obj/item/stock_parts/power_store/cell/infinite/use(used, force = FALSE)
	return used

/obj/item/stock_parts/power_store/cell/infinite/abductor
	name = "void core"
	desc = "An alien power cell that produces energy seemingly out of nowhere."
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "cell"
	maxcharge = STANDARD_CELL_CHARGE * 50
	ratingdesc = FALSE

/obj/item/stock_parts/power_store/cell/infinite/abductor/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/stock_parts/power_store/cell/ethereal
	name = "ahelp it"
	desc = "you sohuldn't see this"
	maxcharge = ETHEREAL_CHARGE_DANGEROUS
	charge = ETHEREAL_CHARGE_FULL
	icon_state = null
	charge_light_type = null
	connector_type = null
	custom_materials = null
	emp_damage_modifier = 0

/obj/item/stock_parts/power_store/cell/ethereal/grind_results()
	return null

/obj/item/stock_parts/power_store/cell/ethereal/examine(mob/user)
	. = ..()
	CRASH("[src.type] got examined by [user]")

/obj/item/stock_parts/power_store/cell/supercap
	name = "supercapacitor"
	desc = "the supercapacitor lives inbetween worlds, part capacitor, part battery."

	icon = 'icons/obj/donk_parts.dmi'
	icon_state ="supercap"
	base_icon_state = "supercap"
	cell_size_prefix = "supercap"
	charge_light_type = null

	maxcharge = AAA_CELL_CHARGE //small capacity, high voltage
	chargerate = AAA_CELL_CHARGE //mega charge
	custom_materials = list(/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT)
