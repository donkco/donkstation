/obj/item/vase

	name = "vase"
	desc = "The potter's vision, fully realized by his fingers."

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "vase-mustard"

	force = 7
	throwforce = 10

	obj_flags = CAN_BE_HIT
	max_integrity = 6
	damage_deflection = 6 //to simulate a hard and brittle material, it resists light blows but shatters suddenly.
	resistance_flags = FIRE_PROOF | ACID_PROOF

	drop_sound = SFX_FOOD_PLATE_DROP
	pickup_sound = SFX_FOOD_PLATE_PICKUP


	/// What sound effect to play when the vase is smashed
	var/break_sound
	/// Which types to spawn when the vase is broken (shards etc)
	var/list/vase_remenants = list(
		/obj/item/pot_shard,
		/obj/item/pot_shard,
		)

/obj/item/vase/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(throwingdatum.gentle)
		return
	take_damage(damage_amount = throwingdatum.speed * 5, damage_type = BRUTE, sound_effect = FALSE, damage_flag = MELEE)

/obj/item/vase/atom_deconstruct(disassembled = TRUE)
	if(disassembled)
		return

	if(vase_remenants?.len)
		for(var/remenant in vase_remenants)
			var/obj/item/spawned_piece = new remenant(loc)
			spawned_piece.pixel_x = rand(-8,8)
			spawned_piece.pixel_y = rand(-8,8)
	if(break_sound)
		playsound(src, break_sound, 100, TRUE)


/obj/item/vase/sus
	name = "suspicious vase"
	desc = "The narrow neck looks poised, as if ready to strike..."

	icon_state ="vase-sus"

/obj/item/vase/eggshell

	icon_state = "vase-eggshell"

/obj/item/vase/teal
	icon_state = "vase-teal"

/// A priceless antique vase. Extremely fragile - shatters from throws, explosions, and dropping.
/obj/item/vase/ming
	name = "Priceless Ming Vase"
	desc = "An ancient Chinese vase of immense cultural and monetary value. The placard reads: 'Han Dynasty, circa 200 BC. On indefinite loan from the Donk Co. Private Collection.' Handle with extreme care."
	icon =  'icons/obj/mingvase.dmi'
	icon_state = "ming_vase"
	max_integrity = 3
	damage_deflection = 3
	///These dont seem to work right now, but we dont have the ming shard icons yet so we'll fix it later.
	vase_remenants = list(
		/obj/item/pot_shard/ming,
		/obj/item/pot_shard/ming,
		/obj/item/pot_shard/ming,
	)
	break_sound = 'sound/effects/glass/glassbr1.ogg'

	/// The mob currently holding this vase, so we can register knockdown signals on them.
	var/mob/living/held_by = null
	/// Extra tiles beyond an explosion's light range within which this vase shatters.
	var/explosion_sensitivity_radius = 2
	/// Timer ref for when its wobbling, cleared if some fucker steadies the vase.
	var/wobble_timer = null

/obj/item/vase/ming/Initialize(mapload)
	. = ..()
	GLOB.ming_vases += src
	AddElement(/datum/element/explosion_sensitive, explosion_sensitivity_radius)
	RegisterSignal(src, COMSIG_ATOM_SENSITIVE_NEARBY_EXPLOSION, PROC_REF(on_nearby_explosion))
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(on_ming_equipped))
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(on_ming_dropped))

/obj/item/vase/ming/Destroy()
	GLOB.ming_vases -= src
	UnregisterSignal(src, COMSIG_ATOM_SENSITIVE_NEARBY_EXPLOSION)
	if(wobble_timer)
		deltimer(wobble_timer)
		wobble_timer = null
	if(held_by)
		UnregisterSignal(held_by, list(COMSIG_LIVING_STATUS_KNOCKDOWN, COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_PARALYZE))
		held_by = null
	return ..()

/// Registers knockdown/stun/paralyze signals on the new holder.
/obj/item/vase/ming/proc/on_ming_equipped(obj/item/source, mob/living/user, slot)
	SIGNAL_HANDLER
	if(!isliving(user))
		return
	held_by = user
	RegisterSignal(held_by, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(on_holder_incapacitated))
	RegisterSignal(held_by, COMSIG_LIVING_STATUS_STUN, PROC_REF(on_holder_incapacitated))
	RegisterSignal(held_by, COMSIG_LIVING_STATUS_PARALYZE, PROC_REF(on_holder_incapacitated))

/// Unregisters knockdown/stun/paralyze signals when dropped.
/obj/item/vase/ming/proc/on_ming_dropped(obj/item/source, mob/living/user)
	SIGNAL_HANDLER
	if(!held_by)
		return
	UnregisterSignal(held_by, list(COMSIG_LIVING_STATUS_KNOCKDOWN, COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_PARALYZE))
	held_by = null

/// The holder was knocked down, stunned, or paralyzed — the vase hits the floor and shatters.
/obj/item/vase/ming/proc/on_holder_incapacitated(mob/living/source, amount, ignore_canstun)
	SIGNAL_HANDLER
	if(amount <= 0)
		return
	take_damage(max_integrity + 1, BRUTE, sound_effect = FALSE, damage_flag = 0)

/// A nearby explosion causes the vase to wobble; if left untouched it tips over in 3 seconds.
/// SSexplosions already verified this object is in range before firing the signal.
/obj/item/vase/ming/proc/on_nearby_explosion(atom/source, turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, explosion_cause, protected)
	SIGNAL_HANDLER
	// Only wobble when sitting on the ground — if held, the holder-incapacitation signals handle it.
	if(held_by || !isturf(loc))
		return
	if(protected)
		return
	start_wobble()

/// Plays the wobble animation and starts the tip-over timer. Resets the timer if already wobbling.
/obj/item/vase/ming/proc/start_wobble()
	// Already wobbling — reset the timer.
	if(wobble_timer)
		deltimer(wobble_timer)
		wobble_timer = null

	if(QDELETED(src))
		return

	// Wobble animation: rock back and forth using rotation

	var/matrix/base = matrix(transform)

	animate(src, transform = base.Turn(15), time = 0.3 SECONDS, flags = ANIMATION_PARALLEL)
	animate(transform = base.Turn(-30), time = 0.4 SECONDS)
	animate(transform = base.Turn(32), time = 0.3 SECONDS)
	animate(transform = base.Turn(-34), time = 0.4 SECONDS)
	animate(transform = base.Turn(36), time = 0.3 SECONDS)
	animate(transform = base.Turn(-38), time = 0.4 SECONDS)
	animate(transform = base.Turn(40), time = 0.3 SECONDS)
	animate(transform = base.Turn(-42), time = 0.3 SECONDS)
	animate(transform = base.Turn(44), time = 0.3 SECONDS)
	animate(transform = base.Turn(-90), time = 0.3 SECONDS)

	visible_message(span_warning("[src] wobbles dangerously!"))
	wobble_timer = addtimer(CALLBACK(src, PROC_REF(tip_over)), 3 SECONDS, TIMER_STOPPABLE | TIMER_DELETE_ME)

/// Called after 3 seconds of wobbling — tips the vase off its spot and shatters it.
/obj/item/vase/ming/proc/tip_over()
	wobble_timer = null
	// Try to slide to a free adjacent turf before shattering.
	var/turf/current = get_turf(src)
	var/list/candidates = list()
	for(var/direction in GLOB.cardinals)
		var/turf/neighbor = get_step(current, direction)
		if(neighbor && neighbor.is_blocked_turf(exclude_mobs = TRUE) == FALSE)
			candidates += neighbor

	var/turf/tip_location = get_turf(src)
	if(candidates.len)
		tip_location = pick(candidates)
	else
		tip_location = get_turf(src)
	visible_message(span_warning("[src] tips over and shatters!"))
	throw_at(tip_location, 1, 0.4)

/obj/item/vase/ming/after_throw(datum/callback/callback)
	. = ..()
	take_damage(max_integrity + 1, BRUTE, sound_effect = FALSE, damage_flag = 0)

/// Steadies the wobbling vase before it tips over.
/obj/item/vase/ming/attack_hand(mob/living/user, list/modifiers)
	if(wobble_timer)
		deltimer(wobble_timer)
		wobble_timer = null
		animate(src, transform = matrix(), time = 0.2 SECONDS, flags = ANIMATION_END_NOW)
		balloon_alert(user, "steadied")
		return
	return ..()

/// Using the vase as a weapon smashes it on impact.
/obj/item/vase/ming/afterattack(atom/target, mob/living/user, list/modifiers)
	if(!isatom(target) || target == user)
		return
	user.visible_message(
		span_warning("[user] smashes [src] against [target]!"),
		span_warning("You smash [src] against [target]!"),
	)
	take_damage(max_integrity + 1, BRUTE, sound_effect = FALSE, damage_flag = 0)

/obj/item/pot_shard/ming
	icon = 'icons/obj/fluff/flora/pot_stuff.dmi'
	icon_state = "ming_shard_1"

/obj/item/pot_shard/ming/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_ICON_STATE)

/obj/item/pot_shard/ming/update_icon_state()
	. = ..()
	icon_state = "ming_shard_[rand(1,16)]"

/obj/item/space_prism
	name = "space prism"
	desc = "A little piece of spectral order in a world of confusion."

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "space_prism"

	w_class =  WEIGHT_CLASS_SMALL

	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT)

/obj/item/space_scanner
	name = "assurance scanner"
	desc = "A device for ensuring correctness by detecting the tell-tale sigs of things not being in order."

	force = 6
	throwforce = 6

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "space_scanner"

	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT, /datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/statuette
	name = "excellence in management award"

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "statuette-award-silver"

	force = 7
	throwforce  = 7

	custom_materials = list(/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/statuette/gold
	name = "syncademy award for outstanding B2B SaaS sales"
	icon_state = "statuette-award-gold"

	custom_materials = list(/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/statuette/goose
	name = "gracile fowl statuette"
	icon_state = "statuette-goose"

	custom_materials = list(/datum/material/rock/marble = SHEET_MATERIAL_AMOUNT)

/obj/item/typewriter
	name = "typewriter"
	desc = "A manual typewriter, the backbone of any modern corporation."
	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "typewriter"

	force = 10
	throwforce = 10
	throw_range = 5
	throw_speed = 1

	w_class = WEIGHT_CLASS_BULKY

	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT, /datum/material/plastic = SHEET_MATERIAL_AMOUNT)

/obj/item/pen_holder
	name = "pen holder"
	desc = "A little dock for your fountain pen."

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "pen_holder"

	w_class = WEIGHT_CLASS_SMALL

	/// The pen we are holding.
	var/obj/item/docked_pen
	/// If we want to spawn without a pen for some reason set to TRUE. (environmental storytelling)
	var/penless = FALSE

/obj/item/pen_holder/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/drag_pickup)
	if(penless)
		return
	docked_pen = new /obj/item/pen/fountain/black(src)

/obj/item/pen_holder/attack_hand(mob/living/user, list/modifiers)
	if(!docked_pen)
		return
	if(!iscarbon(user) || !user.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
		return

	user.put_in_hands(docked_pen)

	if(docked_pen?.loc != src)
		docked_pen = null

/obj/item/pen_holder/attacked_by(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!istype(attacking_item, /obj/item/pen))
		return

	user.transferItemToLoc(attacking_item, src)
	docked_pen = attacking_item

/obj/item/pen/fountain/black

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "fountain-black"

/obj/item/title_plaque
	name = "station executive"
	desc = "Small plaque displaying a big title."

	icon = 'icons/obj/fluff/donk_decoratives.dmi'
	icon_state = "title_plaque"

	obj_flags = UNIQUE_RENAME

	custom_materials = list(/datum/material/bronze = HALF_SHEET_MATERIAL_AMOUNT)
