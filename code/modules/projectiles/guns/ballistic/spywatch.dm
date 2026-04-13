/obj/item/spywatch
	name = "Wristwatch"
	desc = "Time is an illusion, but this watch is pretty."
	slot_flags = ITEM_SLOT_L_TRINKET | ITEM_SLOT_R_TRINKET
	icon = 'icons/obj/toys/toy.dmi'
	icon_state = "dread_ipad"
	worn_icon_state = "dread_ipad"
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/cooldown/mob_cooldown/fire_spywatch)

	///Holds a reference to the gun this watch can fire
	var/obj/item/gun/ballistic/my_gun
	///Whether or not the breech is open (Allowing you to load the weapon)
	var/breech_open = FALSE


/obj/item/spywatch/Initialize(mapload)
	. = ..()
	my_gun = new /obj/item/gun/ballistic/spywatch(src)

/obj/item/spywatch/examine(mob/user)
	. = ..()
	. += span_info("Station Time: [station_time_timestamp()]")

/obj/item/spywatch/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if (.)
		return
	my_gun.item_interaction(user, tool, modifiers)


/obj/item/spywatch/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	return try_fire(interacting_with, user, modifiers)

/obj/item/spywatch/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return try_fire(interacting_with, user, modifiers)

/obj/item/spywatch/proc/try_fire(atom/interacting_with, mob/living/user, list/modifiers)
	if(breech_open)
		balloon_alert(user, "You can't do this while the watch face is open!")
		return FALSE
	var/fired = my_gun.try_fire_gun(interacting_with, user, list2params(modifiers))
	return fired

/obj/item/spywatch/attack_hand(mob/user, list/modifiers)
	if(loc != user || !user.is_holding(src))
		return ..()
	toggle_breech(user)

/obj/item/spywatch/attack_self(mob/user, modifiers)
	. = ..()
	toggle_breech(user)

/obj/item/spywatch/proc/toggle_breech(mob/user)
	breech_open = !breech_open
	if(breech_open)
		balloon_alert(user, "You slide the watch face open.")
		my_gun.unload_ammo(user, TRUE)
	else
		balloon_alert(user, "You slide the watch face closed.")
	return


/obj/item/spywatch/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(breech_open)
		my_gun.item_interaction(user, tool, modifiers)


/obj/item/spywatch/Destroy(force)
	. = ..()
	if(my_gun)
		my_gun.Destroy()

///The gun we put into the spywatch, so we can use it to actually fire the weapon
/obj/item/gun/ballistic/spywatch
	dry_fire_sound = 'sound/items/weapons/gun/pistol/dry_fire.ogg'
	suppressed_sound = 'sound/items/weapons/gun/pistol/shot_suppressed.ogg'
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/spywatch
	spawnwithmagazine = TRUE
	tac_reloads = FALSE
	bolt_type = BOLT_TYPE_NO_BOLT
	can_unsuppress = FALSE
	suppressed = SUPPRESSED_VERY
	pinless = TRUE

	load_sound = null
	load_empty_sound = null
	rack_sound = null
	lock_back_sound = null
	eject_empty_sound = null
	bolt_drop_sound = null

/obj/item/ammo_box/magazine/internal/spywatch
	name = "spywatch internal magazine"
	desc = "Oh god, this shouldn't be here"
	ammo_type = /obj/item/ammo_casing/spywatch
	caliber = CALIBER_2MM
	max_ammo = 1

/obj/item/ammo_casing/spywatch
	name = "'Scylla's Kiss' 2mm mollusk toxin casing"
	desc = "A 2mm bullet casing, a venomous mollusk is painted on the side. Smells fishy."
	icon_state = "762-casing"
	caliber = CALIBER_2MM
	projectile_type = /obj/projectile/bullet/spywatch


/obj/projectile/bullet/spywatch
	name = "'Scylla's Kiss' 2mm mollusk toxin bullet"
	damage = 15
	var/blindness_duration = 10 SECONDS
	var/slurring_duration = 30 SECONDS

/obj/projectile/bullet/spywatch/on_hit(atom/target, blocked = 0, pierce_hit)
	..()
	if(!iscarbon(target))
		return BULLET_ACT_HIT
	var/mob/living/hit_living = target
	if(hit_living.mob_biotypes & MOB_ORGANIC)
		hit_living.adjust_temp_blindness(blindness_duration)
		hit_living.adjust_slurring(slurring_duration)
	return BULLET_ACT_HIT


/datum/action/cooldown/mob_cooldown/fire_spywatch
	name = "Fire Spy Watch"
	desc = "Fire the spy watch at a clicked position."
	cooldown_time = 0 SECONDS

/datum/action/cooldown/mob_cooldown/fire_spywatch/Activate(atom/target_atom)

	var/obj/item/spywatch/spywatch_to_fire = target
	spywatch_to_fire.try_fire(target_atom, owner)
	return TRUE
