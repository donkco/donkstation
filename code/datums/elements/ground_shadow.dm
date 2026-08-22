/datum/element/ground_shadow

	/// List assoc shadow appearances indexed by icon_state
	var/list/shadows

/datum/element/ground_shadow/Attach(datum/target, shadow_key = "circle_shadow", vector/offset = vector(0, 0))
	. = ..()
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE

	var/atom/movable/shadow_caster = target

	if(!LAZYACCESS(shadows, shadow_key))
		var/mutable_appearance/shadow_underlay = new /obj/effect/abstract/shadow()
		shadow_underlay.icon_state = shadow_key
		shadow_underlay.pixel_x = offset.x
		shadow_underlay.pixel_y = offset.y
		LAZYADDASSOC(shadows, shadow_key, shadow_underlay)
	shadow_caster.vis_contents += shadows[shadow_key]

/datum/element/ground_shadow/Detach(datum/source)
	. = ..()
	if(LAZYLEN(shadows))
		var/atom/movable/shadow_caster = source
		shadow_caster.vis_contents -= shadows

/obj/effect/abstract/shadow
	icon = 'icons/effects/shadows.dmi'
	icon_state = "shadow-shelf"
	vis_flags = VIS_INHERIT_PLANE|VIS_INHERIT_LAYER|VIS_INHERIT_DIR|VIS_UNDERLAY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 128
