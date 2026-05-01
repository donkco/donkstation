/**
 * # Old Masters Painting
 *
 * A large, ornate painting by the old masters — one of the widest surviving works.
 * Hung on the wall as a [/obj/structure/old_master_painting_frame], it can be taken down
 * with some careful effort. Once removed, it becomes a [/obj/item/old_master_painting].
 *
 * Too large to fit in a bag. Must be carried in-hand or wrapped with package wrap.
 * When openly carried, bystanders can only identify the painting if they face the front of it.
 * A [/obj/item/old_master_painting/decoy] looks identical from behind.
 */

/*
 * WALL FRAME
 */

/// Wall-mounted frame housing the Old Masters painting.
/obj/structure/old_master_painting_frame
	name = "Old Masters painting"
	desc = "A wide, ornate painting in a gilded frame. One of the widest surviving works by the old masters, depicting a sweeping pastoral landscape in oils."
	icon = 'icons/obj/artheist.dmi'
	icon_state = "fall_of_man"
	layer = SIGN_LAYER
	/// The painting item type this frame produces when taken down.
	var/painting_type = /obj/item/old_master_painting

/obj/structure/old_master_painting_frame/attack_hand(mob/living/user, list/modifiers)
	if(user.combat_mode)
		return ..()
	user.visible_message(
		span_notice("[user] carefully starts to lift the painting from the wall."),
		span_notice("You start carefully lifting the painting from the wall..."),
	)
	if(!do_after(user, 3 SECONDS, target = src))
		return
	user.visible_message(
		span_notice("[user] takes the painting down from the wall."),
		span_notice("You carefully remove the painting from the wall."),
	)
	var/obj/item/old_master_painting/painting = new painting_type(drop_location())
	user.put_in_hands(painting)
	qdel(src)

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/old_master_painting_frame, 32)

/// Decoy frame — visually identical to the real thing from behind; reveals a mediocre modern work from the front.
/obj/structure/old_master_painting_frame/decoy
	name = "modern painting"
	desc = "A mediocre modern painting in an ornate gilt frame. Whoever commissioned this had more money than taste."
	painting_type = /obj/item/old_master_painting/decoy

/*
 * PAINTING ITEMS
 */

/// The Old Masters painting, taken down from its frame.
/obj/item/old_master_painting
	name = "Old Masters painting"
	desc = "A wide painting in a heavy gilded frame. A sweeping pastoral landscape rendered in oils — one of the widest surviving works by the old masters."
	icon = 'icons/obj/artheist.dmi'
	icon_state = "fall_of_man_item"
	inhand_icon_state = "painting-fall"
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 10
	throw_speed = 1
	throw_range = 3
	resistance_flags = FLAMMABLE
	/// The mob directly holding this painting, tracked for directional examine. Null when not held.
	var/mob/living/carrier = null

/obj/item/old_master_painting/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/obj/item/old_master_painting/Destroy()
	if(carrier)
		UnregisterSignal(carrier, COMSIG_ATOM_EXAMINE)
		carrier = null
	return ..()

/**
 * Tracks when this painting is picked up or put down, so we can register/unregister
 * the examine signal on whatever mob is carrying it.
 */
/obj/item/old_master_painting/proc/on_moved(datum/source, atom/old_loc, dir, forced, list/old_locs)
	SIGNAL_HANDLER
	if(carrier && old_loc == carrier)
		UnregisterSignal(carrier, COMSIG_ATOM_EXAMINE)
		carrier = null
	if(isliving(loc))
		carrier = loc
		RegisterSignal(carrier, COMSIG_ATOM_EXAMINE, PROC_REF(on_carrier_examined))

/**
 * Fires when someone examines the mob carrying this painting.
 * Appends directional-aware text to the examine list.
 * If the examiner is directly behind the carrier, they only see the back of the canvas.
 */
/obj/item/old_master_painting/proc/on_carrier_examined(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/mob/living/current_carrier = source

	var/open_direction
	if(current_carrier.is_holding(src) == RIGHT_HANDS)
		open_direction = 90
	else
		open_direction = -90


	if(get_dir(current_carrier, user) & turn(current_carrier.dir, open_direction))
		examine_list += span_notice(get_examine_front_text())
	else
		examine_list += span_notice(get_examine_back_text())

/// Returns the text shown when the examiner can see the front of the painting (carried).
/obj/item/old_master_painting/proc/get_examine_front_text()
	return "They appear to be openly carrying [name]. It's a wide painting in a heavy gilded frame."

/// Returns the text shown when the examiner cannot see the front of the painting (carried).
/obj/item/old_master_painting/proc/get_examine_back_text()
	return "They appear to be carrying a large, framed painting — from this angle you can only make out the back of the canvas."

/// Returns the text shown when the painting is on the ground and the examiner faces the back.
/obj/item/old_master_painting/proc/get_examine_ground_back_text()
	return "From this angle, you can only see the back of the canvas and its gilded frame."

/// When the painting is examined on the ground, note if the examiner is approaching from behind.
/obj/item/old_master_painting/examine(mob/user)
	. = ..()
	if(!isliving(loc) && !(get_dir(src, user) & turn(dir, -90)))
		. += span_notice(get_examine_ground_back_text())

/obj/item/old_master_painting/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/old_master_painting)

/// A modern painting — looks like any other framed canvas from behind, but reveals itself from the front.
/obj/item/old_master_painting/decoy
	name = "modern painting"
	desc = "A mediocre modern painting in a heavy gilded frame. Up close the brushwork is clearly amateur."

/obj/item/old_master_painting/decoy/get_examine_front_text()
	return "They appear to be openly carrying [name]. It's a wide painting in a heavy gilded frame, though the brushwork looks amateurish up close."

/obj/item/old_master_painting/decoy/add_stealing_item_objective()
	return null
