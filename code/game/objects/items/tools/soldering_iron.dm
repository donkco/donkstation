#define SOLDER_RESERVOIR_MAX 1
#define SOLDER_RESERVOIR_CYBERSUN_MAX 8


/obj/item/soldering_iron
	name = "soldering iron"
	desc = "A small soldering iron for attaching and detaching electronic components."

	icon = 'icons/obj/tools.dmi'
	icon_state = "soldering_iron"
	inhand_icon_state = "soldering_iron"
	base_icon_state = "soldering_iron"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/donk_inhands/donk_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/donk_inhands/donk_righthand.dmi'

	force = 4
	damtype = BURN

	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL

	tool_behaviour = TOOL_SOLDERING_IRON
	toolspeed = 1

	/// Amount of solder stored on the iron tip or held internally for automatic retinning. Max capacity defined by SOLDER_RESERVOIR_MAX
	var/solder_reservoir = 0

/obj/item/soldering_iron/proc/apply_solder(obj/item/stack/solder/solder_wire)
	if (solder_reservoir >= SOLDER_RESERVOIR_MAX || !solder_wire)
		return FALSE

	var/solder_refill = min(SOLDER_RESERVOIR_MAX - solder_reservoir, solder_wire.amount)
	solder_reservoir += solder_refill
	solder_wire.use(solder_refill)
	update_appearance()
	return TRUE

/obj/item/soldering_iron/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/stack/solder))
		return apply_solder(attacking_item)
	else
		return ..()

/obj/item/soldering_iron/update_overlays()
	. = ..()
	if(solder_reservoir)
		. +="[base_icon_state]_tinned"

/obj/item/soldering_iron/use(amount)
	. = ..()
	if(solder_reservoir < amount)
		return FALSE

	solder_reservoir -= amount
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/item/soldering_iron/tool_use_check(mob/living/user, amount, heat_required)
	. = ..()
	if(solder_reservoir < amount)
		return FALSE
	else
		return TRUE

/obj/item/soldering_iron/cybersun
	name = "cybersun soldering pen"
	desc = "A Cybersun soldering pen, developed to meet the needs of modern robotics engineering."

	icon_state = "soldering_iron-cybersun"
	inhand_icon_state = "soldering_iron-cybersun"
	base_icon_state = "soldering_iron-cybersun"

	toolspeed = 0.6

/obj/item/soldering_iron/cybersun/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/soldering_iron/cybersun/update_overlays()
	. = ..()
	if(solder_reservoir)
		. +="[base_icon_state]_led"

/obj/item/soldering_iron/cybersun/apply_solder(obj/item/stack/solder/solder_wire)
	. = ..()
	if(.)
		playsound(src,'sound/machines/computer/keyboard_clicks_6.ogg', 50, TRUE)

/obj/item/stack/solder
	name = "solder"
	desc = "A spool of flux cored solder wire."

	icon = 'icons/obj/tools.dmi'
	icon_state = "solder"
	base_icon_state = "solder"


	obj_flags = CONDUCTS_ELECTRICITY
	w_class = WEIGHT_CLASS_TINY

	max_amount = 10
	amount = 10
	material_type = /datum/material/lead
	mats_per_unit = list(/datum/material/lead = SHEET_MATERIAL_AMOUNT / 10)

#undef SOLDER_RESERVOIR_MAX
#undef SOLDER_RESERVOIR_CYBERSUN_MAX
