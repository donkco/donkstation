/obj/item/grenade/dazzle
	name = "dazzle grenade"
	icon = 'icons/obj/weapons/donk_grenade.dmi'
	icon_state = "dazzle"
	inhand_icon_state = "flashbang"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	possible_fuse_time = list("3", "4", "5")

/obj/item/grenade/dazzle/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return
	update_mob()
	var/turf/dazzle_turf = get_turf(src)
	if(!dazzle_turf)
		return
	playsound(dazzle_turf, 'sound/effects/explosion/dazzle_grenade.ogg', 100, FALSE, 8, 0.9)
	new /obj/effect/temp_visual/dazzle(dazzle_turf)
	qdel(src)

/obj/item/storage/belt/grenade/dazzle
	name = "dazzling belt"

/obj/item/storage/belt/grenade/dazzle/PopulateContents()
	new /obj/item/grenade/dazzle(src)
	new /obj/item/grenade/dazzle(src)
	new /obj/item/grenade/dazzle(src)
	new /obj/item/grenade/dazzle(src)
	new /obj/item/grenade/dazzle(src)
	new /obj/item/grenade/dazzle(src)
	new /obj/item/grenade/dazzle(src)

/obj/effect/temp_visual/dazzle
	name = "lumious orb"
	icon = 'icons/effects/donk_effects_96x96.dmi'
	icon_state = "dazzle_k"
	base_icon_state = "dazzle_k"
	mouse_opacity = MOUSE_OPACITY_ICON
	duration = 12 SECONDS
	plane = ABOVE_LIGHTING_PLANE	//Our effect orbs
	alpha = 0

	var/obj/effect/split_spectrum/r_orb
	var/obj/effect/split_spectrum/g_orb
	var/obj/effect/split_spectrum/b_orb
	var/obj/effect/dazzle_field

	SET_BASE_VISUAL_PIXEL(-32,-0)

/obj/effect/temp_visual/dazzle/Destroy()
	. = ..()
	QDEL_NULL(r_orb)
	QDEL_NULL(g_orb)
	QDEL_NULL(b_orb)
	QDEL_NULL(dazzle_field)


/obj/effect/split_spectrum
	name = "lumious orb"
	plane = ABOVE_LIGHTING_PLANE
	layer = 5
	icon = 'icons/effects/donk_effects_96x96.dmi'
	blend_mode = BLEND_ADD
	appearance_flags = RESET_COLOR | PIXEL_SCALE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT


/obj/effect/split_spectrum/Initialize()
	. = ..()
	flick("[base_icon_state]_grow", src)


/obj/effect/split_spectrum/red
	icon_state = "dazzle_r"
	base_icon_state = "dazzle_r"

/obj/effect/split_spectrum/green
	icon_state = "dazzle_g"
	base_icon_state = "dazzle_g"

/obj/effect/split_spectrum/blue
	icon_state = "dazzle_b"
	base_icon_state = "dazzle_b"

/obj/effect/temp_visual/dazzle/Initialize()
	. = ..()
	b_orb = new /obj/effect/split_spectrum/blue()
	vis_contents += b_orb
	g_orb = new /obj/effect/split_spectrum/green()
	vis_contents += g_orb
	r_orb = new /obj/effect/split_spectrum/red()
	vis_contents += r_orb


	dazzle_field = new /obj/effect/dazzle_field()
	vis_contents += dazzle_field

	flick("[base_icon_state]_grow", src)

	var/horizontal_wiggle = 2
	var/orb_rise_duration = 3 SECONDS
	var/wiggle_speed = 100 MILLISECONDS


	var/trisplit_x = 4
	var/trisplit_z = 4
	var/trisplit_ease = ELASTIC_EASING | EASE_OUT
	var/trisplit_return_ease = SINE_EASING | EASE_IN
	var/split_speed = 2
	var/split_delay = 30



	animate(r_orb, time = wiggle_speed, pixel_x = horizontal_wiggle, delay = 1 SECONDS)
	animate(time = wiggle_speed, pixel_x = 0)
	animate(time = wiggle_speed, pixel_x = -horizontal_wiggle)
	animate(time = wiggle_speed, pixel_x = 0)
	animate(time = wiggle_speed, pixel_x = horizontal_wiggle)
	animate(time = wiggle_speed, pixel_x = 0)
	animate(time = wiggle_speed, pixel_x = -horizontal_wiggle)
	animate(time = wiggle_speed, pixel_x = 0)
	animate( time = split_speed, pixel_x = -trisplit_x, pixel_z = trisplit_z, easing = trisplit_ease, delay = 0.5 SECONDS)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = trisplit_x, pixel_z = -trisplit_z, easing = trisplit_ease)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = 0, pixel_z = trisplit_z, easing = trisplit_ease, delay = split_delay)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = 0, pixel_z = -trisplit_z, easing = trisplit_ease)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = trisplit_x, pixel_z = trisplit_z, easing = trisplit_ease, delay = split_delay)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = -trisplit_x, pixel_z = -trisplit_z, easing = trisplit_ease)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)


	animate(g_orb, time = split_speed, pixel_x = trisplit_x, pixel_z = trisplit_z, easing = trisplit_ease, delay = 1.5 SECONDS + wiggle_speed * 8)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = -trisplit_x, pixel_z = -trisplit_z, easing = trisplit_ease)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = trisplit_x, pixel_z = -trisplit_z, easing = trisplit_ease, delay = split_delay)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = -trisplit_x, pixel_z = trisplit_z, easing = trisplit_ease)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = 0, pixel_z = -trisplit_z, easing = trisplit_ease, delay = split_delay)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = 0, pixel_z = trisplit_z, easing = trisplit_ease)
	animate(time = split_speed, pixel_x = 0, pixel_z = 0, easing = trisplit_return_ease)


	animate(b_orb, time = wiggle_speed, pixel_x = -2, delay = 1 SECONDS)
	animate(time = wiggle_speed, pixel_x = 0)
	animate(time = wiggle_speed, pixel_x = 2)
	animate(time = wiggle_speed, pixel_x = 0)
	animate(time = wiggle_speed, pixel_x = -2)
	animate(time = wiggle_speed, pixel_x = 0)
	animate(time = wiggle_speed, pixel_x = 2)
	animate(time = wiggle_speed, pixel_x = 0)
	animate(time = split_speed, pixel_x = 0, pixel_z = -trisplit_z, easing = trisplit_ease, delay = 1 SECONDS)
	animate(time = split_speed, pixel_x = -0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = 0, pixel_z = trisplit_z, easing = trisplit_ease)
	animate(time = split_speed, pixel_x = -0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = -trisplit_x, pixel_z = trisplit_z, easing = trisplit_ease, delay = split_delay)
	animate(time = split_speed, pixel_x = -0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = -0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = trisplit_x, pixel_z = -trisplit_z, easing = trisplit_ease)
	animate(time = split_speed, pixel_x = -0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = -trisplit_x, pixel_z = trisplit_z, easing = trisplit_ease, delay = split_delay)
	animate(time = split_speed, pixel_x = -0, pixel_z = 0, easing = trisplit_return_ease)
	animate(time = split_speed, pixel_x = trisplit_x, pixel_z = -trisplit_z, easing = trisplit_ease)
	animate(time = split_speed, pixel_x = -0, pixel_z = 0, easing = trisplit_return_ease)

	animate(src, time = orb_rise_duration, color = list(1,1,1, 1,1,1, 1,1,1, 0.5, 0.5, 0.5))
	animate(time = orb_rise_duration, color = list(1,1,1, 1,1,1, 1,1,1, 0, 0, 0))

/obj/effect/dazzle_field
	icon = 'icons/effects/donk_effects_256x256.dmi'
	icon_state = "dazzle_field"
	plane = MASSIVE_OBJ_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = RESET_COLOR | RESET_ALPHA | KEEP_APART | PIXEL_SCALE
	SET_BASE_VISUAL_PIXEL(-80,-96)

/obj/effect/dazzle_field/Initialize(mapload)
	. = ..()
	flick("dazzle_field-start", src)
