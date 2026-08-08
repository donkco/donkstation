
/obj/item/hatchet/tomahawk
	name = "tomahawk"
	desc = "You tactitically assertain this to be a shiny metal axe. It is designed for maximum warfighting lethality."

	icon = 'icons/obj/weapons/donk_weapons.dmi'
	icon_state = "tomahawk"
	icon_angle = -23
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi' // TODO change this
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'

	force = 20
	throwforce = 20
	throw_range = 7
	embed_type = /datum/embedding/tomahawk
	custom_materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3)
	attack_verb_continuous = list("chops", "tears", "lacerates", "cuts", "savages")
	attack_verb_simple = list("chop", "tear", "lacerate", "cut", "savage")

/datum/embedding/tomahawk
	pain_mult = 6
	embed_chance = 65
	fall_chance = 10

/obj/item/gun/energy/laser/agent_pistol
	name = "laser pistol"
	desc = "Agent."
	icon = 'icons/obj/weapons/donk_weapons_wide.dmi'
	icon_state = "agent_pistol"
	base_icon_state = "agent_pistol"
	inhand_icon_state = "agent_pistol"
	lefthand_file = 'icons/mob/inhands/donk_inhands/donk_wide_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/donk_inhands/donk_wide_righthand.dmi'

	w_class = WEIGHT_CLASS_SMALL
	cell_type =  /obj/item/stock_parts/power_store/battery_array/two_aa

	electronics_overlay_postition = TEMP_VECTOR_TRICK(8, 6)

/obj/item/gun/energy/laser/agent_pistol/can_attach(obj/item/gun_attachment/attachment)
	if(istype(attachment, /obj/item/gun_attachment/fluoressor))
		return TRUE
	return ..()

/obj/item/gun_attachment
	name = "gun attachment"
	icon = 'icons/obj/weapons/guns/attachments.dmi'
	icon_state = "suppressor"

	/// attachment point vector,this is the pixel coordinate where you want the sprite to connect with the gun. This is subtracted from the guns mounting point vector.

	var/list/attachment_point = TEMP_VECTOR_TRICK(5, 12)
	/// Sound to play when attaching this to a gun. If null, no sound will play.
	var/attach_sound = 'sound/items/pen_click.ogg'
	/// modified fire sound
	var/modified_fire_sound = null

/// Modifies the gun's characteristics.
/obj/item/gun_attachment/proc/attach(obj/item/gun/host_gun)
	if(attach_sound)
		playsound(host_gun, attach_sound, 100, TRUE)
	RegisterSignal(host_gun, COMSIG_GUN_PREFIRE, PROC_REF(on_gun_prefire))
	set_up_fire_sound(host_gun)

/// return the gun's characteristics to normal
/obj/item/gun_attachment/proc/detach(obj/item/gun/host_gun)
	host_gun.fire_sound = initial(host_gun.fire_sound)
	UnregisterSignal(host_gun, COMSIG_GUN_PREFIRE)

/obj/item/gun_attachment/proc/on_gun_prefire(obj/item/gun/firing_gun, user, target)
	return

/obj/item/gun_attachment/proc/set_up_fire_sound(obj/item/gun/vocalist)
	return

/obj/item/gun_attachment/suppressor
	name = "suppressor"
	/// Supression level
	var/mod_supression = SUPPRESSED_QUIET

/obj/item/gun_attachment/suppressor/attach(obj/item/gun/host_gun)
	host_gun.suppressed = max(host_gun.suppressed, mod_supression)
	host_gun.can_muzzle_flash = FALSE
	return ..()

/obj/item/gun_attachment/suppressor/detach(obj/item/gun/host_gun)
	host_gun.suppressed = initial(host_gun.suppressed)
	host_gun.can_muzzle_flash = initial(host_gun.can_muzzle_flash)
	return ..()


/obj/item/gun_attachment/fluoressor
	name = "fluoressor"
	icon_state = "fluoressor"
	attachment_point =  TEMP_VECTOR_TRICK(8, 17)
	///Our projectile_type
	var/obj/item/ammo_casing/laser/fluorscence_projectile

/obj/item/gun_attachment/fluoressor/on_gun_prefire(obj/item/gun/firing_gun, user, target)
	. = ..()
	// If our host is capable of producing light via the stimulated emission of radiation,
	// We absorb that light and reemitt it at a different wavelength. This is called fluorescence.
	// Mechanically, this is represented by swapping out the projectile right before the gun fires.
	if(istype(firing_gun, /obj/item/gun/energy/laser) && fluorscence_projectile)
		if(isatom(firing_gun.chambered))
			QDEL_NULL(firing_gun.chambered)

		firing_gun.chambered = new fluorscence_projectile(firing_gun)

/obj/item/gun_attachment/fluoressor/ultraviolet
	name = "ultraviolet fluoressor"
	icon_state = "fluoressor-uv"
	attachment_point =  TEMP_VECTOR_TRICK(8, 16)
	fluorscence_projectile = /obj/item/ammo_casing/energy/laser/ultraviolet

/obj/item/ammo_casing/energy/laser/ultraviolet
	projectile_type = /obj/projectile/beam/laser/ultraviolet
	e_cost = LASER_SHOTS(10, STANDARD_CELL_CHARGE * 2)
	select_name = "tan"
	muzzle_flash_color = COLOR_MAGENTA
	fire_sound = 'sound/items/weapons/laser.ogg'
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/uv

/obj/effect/temp_visual/dir_setting/firing_effect/uv
	icon = 'icons/obj/weapons/guns/donk_projectiles.dmi'
	icon_state = "firing_effect-uv"
	duration = 4

/obj/projectile/beam/laser/ultraviolet
	name = "UV laser"
	icon = 'icons/obj/weapons/guns/donk_projectiles.dmi'
	icon_state = "laser-uv"
	damage = 30
	armor_flag = LASER
	eyeblur = 6 SECONDS
	impact_effect_type = /obj/effect/temp_visual/impact_effect/uv
	light_power = 1.2
	light_color = COLOR_MAGENTA
	wound_bonus = -10

/obj/effect/temp_visual/impact_effect/uv
	icon = 'icons/obj/weapons/guns/donk_projectiles.dmi'
	icon_state = "impact-uv"
	duration = 7

/obj/item/gun_attachment/fluoressor/infrared
	name = "infrared fluoressor"
	icon_state = "fluoressor-ir"
	attachment_point = TEMP_VECTOR_TRICK(7, 17)
	fluorscence_projectile = /obj/item/ammo_casing/energy/laser/infrared

/obj/item/ammo_casing/energy/laser/infrared
	projectile_type = /obj/projectile/beam/laser/infrared
	e_cost = LASER_SHOTS(10, STANDARD_CELL_CHARGE * 2)
	select_name = "heat"
	muzzle_flash_color = COLOR_INFRARED
	fire_sound = 'sound/items/weapons/laser.ogg'
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/ir


/obj/effect/temp_visual/dir_setting/firing_effect/ir
	icon = 'icons/obj/weapons/guns/donk_projectiles.dmi'
	icon_state = "firing_effect-ir"
	duration = 4

/obj/projectile/beam/laser/infrared
	name = "IR laser"
	icon = 'icons/obj/weapons/guns/donk_projectiles.dmi'
	icon_state = "laser-ir"
	damage = 15
	armor_flag = LASER
	impact_effect_type = /obj/effect/temp_visual/impact_effect/ir
	light_power = 1.2
	light_color = COLOR_INFRARED

/obj/projectile/beam/laser/infrared/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ir_irradiant)


/obj/effect/temp_visual/impact_effect/ir
	icon = 'icons/obj/weapons/guns/donk_projectiles.dmi'
	icon_state = "impact-ir"
	duration = 7
