/obj/item/spywatch
	name = "Watch"
	desc = "Time is an illusion, but this watch is pretty."
	icon = 'icons/map_icons/items/pda.dmi'
	icon_state = "/obj/item/modular_computer/pda"
	post_init_icon_state = "pda"
	worn_icon_state = "nothing"
	base_icon_state = "tablet"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	inhand_icon_state = "electronic"

	///Holds a reference to the gun this watch can fire
	var/obj/item/gun/my_gun = /obj/item/gun/ballistic/spywatch

/obj/item/spywatch/Initialize(mapload)
	. = ..()
	my_gun

/obj/item/spywatch/Destroy(force)
	. = ..()
	if(my_gun)
		my_gun.Destroy()


///The abstract gun we put into the spywatch, so we can use it to actually fire the weapon
/obj/item/gun/ballistic/spywatch
	dry_fire_sound = 'sound/items/weapons/gun/pistol/dry_fire.ogg'
	suppressed_sound = 'sound/items/weapons/gun/pistol/shot_suppressed.ogg'
	accepted_magazine_type = /obj/item/ammo_casing/c9mm
	spawnwithmagazine = TRUE

/obj/item/gun/ballistic/spywatch/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/S = new(src)
	install_suppressor(S)
