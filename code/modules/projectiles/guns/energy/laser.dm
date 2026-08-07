/obj/item/gun/energy/laser
	name = "\improper Type 5 laser gun"
	desc = "The Type 5 Heat Delivery System, developed by Nanotrasen. The workhorse of Nanotrasen's security forces."
	icon_state = "laser"
	inhand_icon_state = "laser"
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT)
	ammo_type = list(/obj/item/ammo_casing/energy/laser)
	cell_type = /obj/item/stock_parts/power_store/battery_array/two_aa
	shaded_charge = TRUE
	light_color = COLOR_SOFT_RED
	barrel_mount_position = TEMP_VECTOR_TRICK(31, 20)

/obj/item/gun/energy/laser/Initialize(mapload)
	. = ..()
	// Only regular lasguns can be slapcrafted
	if(type != /obj/item/gun/energy/laser)
		return
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/laser/xraylaser, /datum/crafting_recipe/laser/hellgun, /datum/crafting_recipe/laser/ioncarbine)
	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/gun/energy/laser/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 18, \
		overlay_y = 12)

/obj/item/gun/energy/laser/pistol
	name = "\improper Type 5/C laser pistol"
	desc = "The Type 5 Heat Delivery System, Compact Variant, developed by Nanotrasen. The workhorse of Nanotrasen's security forces, but in a more portable size. \
		Sacrifices some stopping power and capacity for ease of carry and faster charging."
	icon_state = "laser_pistol"
	w_class = WEIGHT_CLASS_NORMAL
	projectile_damage_multiplier = 0.8
	cell_type = /obj/item/stock_parts/power_store/battery_array/four_aaa
	ammo_type = list(/obj/item/ammo_casing/energy/laser)
	barrel_mount_position = TEMP_VECTOR_TRICK(30, 18)

/obj/item/gun/energy/laser/pistol/add_seclight_point()
	return

/obj/item/gun/energy/laser/assault
	name = "\improper Type 5/A assault laser rifle"
	desc = "The Type 5 Heat Delivery System, Assault Variant, developed by Nanotrasen. The workhorse of Nanotrasen's security forces and paramilitary organizations. \
		While it sacrifices some stopping power and ease of use, its laser system is remarkably efficient and it boasts some resistance against electromagnetic interference."
	icon = 'icons/obj/weapons/guns/wide_guns.dmi'
	icon_state = "assault_laser"
	inhand_icon_state = "assault_laser"
	worn_icon_state = "assault_laser"
	slot_flags = ITEM_SLOT_BACK
	burst_size = 2
	fire_delay = 1
	ammo_type = list(/obj/item/ammo_casing/energy/laser/assault)
	cell_type = /obj/item/stock_parts/power_store/battery_array/double_d
	emp_resistance = 2
	weapon_weight = WEAPON_HEAVY
	projectile_speed_multiplier = 1.5
	barrel_mount_position = TEMP_VECTOR_TRICK(45, 17)
	electronics_overlay_postition = TEMP_VECTOR_TRICK(25, 14)
	SET_BASE_PIXEL(-8, 0)

/obj/item/gun/energy/laser/assault/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 18, \
		overlay_y = 30)

/obj/item/gun/energy/laser/practice
	name = "practice laser gun"
	desc = "A modified version of the Type 5 laser gun. Fires entirely harmless bolts of directed energy. Safe AND entertaining to fire with abandon."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/practice)
	clumsy_check = FALSE
	item_flags = NONE
	gun_flags = NOT_A_REAL_GUN

/obj/item/gun/energy/laser/retro
	name ="\improper Type 1 laser gun"
	desc = "The Type 1 Heat Delivery System, developed by Nanotrasen. No longer used by Nanotrasen's private security or military forces. Nevertheless, \
		it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."
	icon_state = "retro"
	ammo_x_offset = 3
	barrel_mount_position = TEMP_VECTOR_TRICK(29, 18)

/obj/item/gun/energy/laser/soul
	name ="\improper Type 3 laser gun"
	desc = "The Type 3 Heat Delivery System, developed by Nanotrasen. Quite possibly the most popular model of HDS ever made by Nanotrasen. \
		They don't make them like they used to."
	icon_state = "laser_soulful"
	inhand_icon_state = "laser_soulful"
	ammo_x_offset = 1

/obj/item/gun/energy/laser/carbine
	name = "\improper Type 5/R laser carbine"
	desc = "The burst fire Type 5/R Rapid Heat Delivery System, developed by Nanotrasen. Capable of firing a sustained volley of directed energy projectiles, though each individual projectile lacks the punch of the Type 5."
	icon_state = "laser_carbine"
	burst_size = 2
	fire_delay = 2
	projectile_damage_multiplier = 0.75
	projectile_speed_multiplier = 1.5
	ammo_type = list(/obj/item/ammo_casing/energy/laser/carbine)
	cell_type = /obj/item/stock_parts/power_store/cell/d
	weapon_weight = WEAPON_MEDIUM
	barrel_mount_position = TEMP_VECTOR_TRICK(31, 17)

/obj/item/gun/energy/laser/cybersun
	name = "\improper Cybersun S-120"
	desc = "A laser gun primarily used by syndicate security guards. It fires a rapid spray of low-power plasma beams."
	icon_state = "cybersun_s120"
	inhand_icon_state = "s120"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/cybersun)
	cell_type = /obj/item/stock_parts/power_store/cell/ba5800
	spread = 14
	pin = /obj/item/firing_pin/implant/pindicate
	ammo_x_offset = 1
	barrel_mount_position = TEMP_VECTOR_TRICK(29, 17)

/obj/item/gun/energy/laser/cybersun/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.15 SECONDS, allow_akimbo = FALSE)

/obj/item/gun/energy/laser/cybersun/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/energy/laser/carbine/practice
	name = "practice laser carbine"
	desc = "A modified version of the Type 5/R laser carbine. Fires entirely harmless bolts of directed energy. Safe AND entertaining to fire with abandon."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/carbine/practice)
	clumsy_check = FALSE
	item_flags = NONE
	gun_flags = NOT_A_REAL_GUN

/obj/item/gun/energy/laser/retro/old
	desc = "The NT Type 1 Heat Delivery System, developed by Nanotrasen. This one looks downright ancient. What the hell happened to it?"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/old)

/obj/item/gun/energy/laser/hellgun
	name = "\improper Type 4 'hellfire' laser gun"
	desc = "The Type 4 Heat Delivery System, developed by Nanotrasen. Technically speaking, it is an improvement. \
		Legally speaking, possession of this weapon is restricted in most occupied sectors of space. \
		The Type 4 is notorious for its ability to render victims a carbonized husk with ease, melting flesh and bone as easily as butter. \
		A painful, gruesome death awaits anyone on the wrong end of this gun."
	icon_state = "hellgun"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/hellfire)
	ammo_x_offset = 1
	light_color = COLOR_AMMO_HELLFIRE
	barrel_mount_position = TEMP_VECTOR_TRICK(31, 16)

/obj/item/gun/energy/laser/captain
	name = "antique laser gun"
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. It is decorated with assistant leather and chrome. \
		The object menaces with spikes of energy. On the item is an image of Space Station 13. The station is exploding."
	icon_state = "caplaser"
	w_class = WEIGHT_CLASS_NORMAL
	inhand_icon_state = null
	force = 10
	ammo_x_offset = 3
	selfcharge = 1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1
	ammo_type = list(/obj/item/ammo_casing/energy/laser/hellfire)
	light_color = COLOR_AMMO_HELLFIRE
	barrel_mount_position = TEMP_VECTOR_TRICK(31, 17)

/obj/item/gun/energy/laser/captain/scattershot
	name = "scatter shot laser rifle"
	desc = "An industrial-grade heavy-duty laser rifle with a modified laser lens to scatter its shot into multiple smaller lasers. \
		The inner-core can self-charge for theoretically infinite use."
	icon_state = "lasercannon"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "laser"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter, /obj/item/ammo_casing/energy/laser)
	shaded_charge = FALSE
	ammo_x_offset = 1
	barrel_mount_position = TEMP_VECTOR_TRICK(32, 18)

/obj/item/gun/energy/laser/cyborg
	can_charge = FALSE
	desc = "An energy-based laser gun that draws power from the cyborg's internal energy cell directly. So this is what freedom looks like?"
	cell_type = /obj/item/stock_parts/power_store/cell/aaa
	use_cyborg_cell = TRUE
	ammo_x_offset = 1

/obj/item/gun/energy/laser/cyborg/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_ALL)

/obj/item/gun/energy/laser/scatter
	name = "scatter laser gun"
	desc = "A laser gun equipped with a refraction kit that spreads bolts."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter, /obj/item/ammo_casing/energy/laser)
	ammo_x_offset = 1

/obj/item/gun/energy/laser/scatter/shotty
	name = "energy shotgun"
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "cshotgun"
	inhand_icon_state = "shotgun"
	desc = "A combat shotgun gutted and refitted with an internal energy emission system. Can switch between scattered disabler shots and taser electrodes."
	shaded_charge = FALSE
	pin = /obj/item/firing_pin/implant/mindshield
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter/disabler, /obj/item/ammo_casing/energy/electrode)
	automatic_charge_overlays = FALSE
	ammo_x_offset = 1
	barrel_mount_position = TEMP_VECTOR_TRICK(32, 16)

///Laser Cannon

/obj/item/gun/energy/lasercannon
	name = "accelerator laser cannon"
	desc = "An advanced laser cannon that does more damage the farther away the target is."
	icon_state = "lasercannon"
	inhand_icon_state = "laser"
	worn_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/laser/accelerator)
	cell_type = /obj/item/stock_parts/power_store/cell/ba5800
	pin = null
	ammo_x_offset = 3
	barrel_mount_position = TEMP_VECTOR_TRICK(32, 18)

///X-ray gun

/obj/item/gun/energy/laser/xray
	name = "\improper Type 6 X-ray laser gun"
	desc = "The Type 6 Heat Delivery System, developed by Nanotrasen. \
		Capable of expelling concentrated 'X-ray' blasts that pass through multiple soft targets and heavier materials."
	icon_state = "xray"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/xray)
	cell_type = /obj/item/stock_parts/power_store/cell/d
	ammo_x_offset = 3
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3.5,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT,
	)
	shaded_charge = FALSE
	light_color = LIGHT_COLOR_GREEN
	barrel_mount_position = TEMP_VECTOR_TRICK(31, 16)

////////Laser Tag////////////////////

/obj/item/gun/energy/laser/bluetag
	name = "laser tag gun"
	icon_state = "bluetag"
	desc = "A retro laser gun modified to fire harmless blue beams of light. Sound effects included!"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/bluetag)
	item_flags = NONE
	clumsy_check = FALSE
	pin = /obj/item/firing_pin/tag/blue
	ammo_x_offset = 2
	selfcharge = TRUE
	gun_flags = NOT_A_REAL_GUN
	barrel_mount_position = TEMP_VECTOR_TRICK(29, 18)

/obj/item/gun/energy/laser/bluetag/hitscan
	ammo_type = list(/obj/item/ammo_casing/energy/laser/bluetag/hitscan)

/obj/item/gun/energy/laser/redtag
	name = "laser tag gun"
	icon_state = "redtag"
	desc = "A retro laser gun modified to fire harmless beams red of light. Sound effects included!"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/redtag)
	item_flags = NONE
	clumsy_check = FALSE
	pin = /obj/item/firing_pin/tag/red
	ammo_x_offset = 2
	selfcharge = TRUE
	gun_flags = NOT_A_REAL_GUN
	barrel_mount_position = TEMP_VECTOR_TRICK(29, 18)

/obj/item/gun/energy/laser/redtag/hitscan
	ammo_type = list(/obj/item/ammo_casing/energy/laser/redtag/hitscan)

// luxury shuttle funnies
/obj/item/firing_pin/paywall/luxury
	multi_payment = TRUE
	payment_amount = 20

/obj/item/gun/energy/laser/luxurypaywall
	name = "luxurious laser gun"
	desc = "A laser gun modified to cost 20 credits to fire. Point towards poor people."
	pin = /obj/item/firing_pin/paywall/luxury

