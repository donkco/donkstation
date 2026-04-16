/**
 * ##remote control
 *
 * Used on living mobs when they are meant to be remote controlled by another mob
 * Holds a reference to an old mind & body, to put them back in
 * once you stop remote controlling the target mob.
 * When the controlling mob gets knocked down or otherwise incapacitated, the mind will be put back into the old body.
 */
/datum/component/remote_control
	///The old mind we will be put back into when parent is being deleted.
	var/datum/weakref/controller_mind_ref
	///The old body we will be put back into when parent is being deleted.
	var/datum/weakref/controller_body_ref
	///Destroy the controlled entity when control is lost for some reason?
	var/destroy_on_control_loss = FALSE
	///Create a mapview of the controllers vicinity?
	var/create_controller_view = TRUE
	///A mapview that shows you the direct area of the controller. Some spatial awareness!
	var/atom/movable/screen/map_view/controller_view
	///Action that allows us to return to our body early if we want to stop controlling the mob for some reason.
	var/datum/action/cooldown/end_remote_control/end_remote_control
	/// Range in which we can see from the controllers perspective
	var/cam_range = 4
	/// Detects when we move to update the camera view
	var/datum/movement_detector/tracker


	///Should the view sometimes glitch when controlling the mob?
	var/glitchy_view = TRUE
	///min interval of the glitchy view
	var/glitchy_view_interval_min = 4 SECONDS
	///max interval of the glitchy view
	var/glitchy_view_interval_max = 10 SECONDS
	///Intensity of the glitchy view
	var/glitch_intensity = 10
	///Size of the glitchy view
	var/glitch_size = 7.5
	///Offset the glitchiness will travel during the animation, higher values will make it more noticeable
	var/glitch_offset = 50
	///Duration of the glitchy view
	var/glitch_duration = 0.5 SECONDS
	///Duration of the glitchy view going back to normal
	var/glitch_undo_duration = 0.5 SECONDS
	///Offset the glitchiness will travel during the animation, higher values will make it more noticeable
	var/glitch_undo_offset = 100

	///Do we have a noise overlay when controlling a mob?
	var/noisy_view = TRUE

/datum/component/remote_control/Initialize(datum/mind/controller_mind, mob/living/controller_body, destroy_on_control_loss)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/controlled_mob = parent

	if(controlled_mob.stat == DEAD)
		return COMPONENT_INCOMPATIBLE

	src.controller_mind_ref = WEAKREF(controller_mind)
	if(istype(controller_body))
		ADD_TRAIT(controller_body, TRAIT_MIND_TEMPORARILY_GONE, REF(src))
		src.controller_body_ref = WEAKREF(controller_body)

	src.destroy_on_control_loss = destroy_on_control_loss


	controlled_mob.PossessByPlayer(controller_body.key)

	RegisterSignals(controller_body, COMSIG_QDELETING, PROC_REF(return_mind_to_controller))

	end_remote_control = new(controlled_mob)
	end_remote_control.Grant(controlled_mob)

	var/static/list/capacity_signals = list(
		COMSIG_LIVING_STATUS_KNOCKDOWN,
		COMSIG_LIVING_STATUS_PARALYZE,
		COMSIG_LIVING_STATUS_STUN,
		COMSIG_QDELETING
	)
	RegisterSignals(controller_body, capacity_signals, PROC_REF(return_mind_to_controller))

	if(create_controller_view)
		controller_view = new /atom/movable/screen/map_view()
		tracker = new /datum/movement_detector(controller_body, CALLBACK(src, PROC_REF(update_view)))
		controller_view.generate_view("remote_control_map")
		show_controller_view()
		RegisterSignal(controller_body, COMSIG_POPUP_CLEARED, PROC_REF(on_popup_clear))

	if(glitchy_view)
		addtimer(CALLBACK(src, PROC_REF(start_glitchy_view)), rand(glitchy_view_interval_min, glitchy_view_interval_max))

	if(noisy_view)
		controlled_mob.overlay_fullscreen("static_noise", /atom/movable/screen/fullscreen/static_noise, 0)


/datum/component/remote_control/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(return_mind_to_controller))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(return_mind_to_controller))

/datum/component/remote_control/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_QDELETING)
	UnregisterSignal(parent, COMSIG_LIVING_DEATH)

/datum/component/remote_control/Destroy(force)
	if(controller_body_ref)
		UnregisterSignal(controller_body_ref.resolve(), list(
			COMSIG_LIVING_STATUS_KNOCKDOWN,
			COMSIG_LIVING_STATUS_PARALYZE,
			COMSIG_LIVING_STATUS_STUN,
			COMSIG_QDELETING,
		))
	return_mind_to_controller()
	return ..()

/datum/component/remote_control/proc/start_glitchy_view()
	if(!glitchy_view)
		return
	var/mob/living/living_parent = parent
	var/atom/movable/plane_master_controller/game_plane_master_controller = living_parent.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.add_filter("remote_control_glitch", 10, wave_filter(0, glitch_intensity, 0, 0, WAVE_SIDEWAYS))
	for(var/filter in game_plane_master_controller.get_filters("remote_control_glitch"))
		animate(filter, size = glitch_size, offset = glitch_offset, time = glitch_duration, loop = FALSE, easing = CUBIC_EASING|EASE_OUT)
	addtimer(CALLBACK(src, PROC_REF(undo_glitchy_view)), glitch_duration)

/datum/component/remote_control/proc/undo_glitchy_view()
	var/mob/living/living_parent = parent
	var/atom/movable/plane_master_controller/game_plane_master_controller = living_parent.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	for(var/filter in game_plane_master_controller.get_filters("remote_control_glitch"))
		animate(filter, size = 0, offset = glitch_undo_offset, time = glitch_undo_duration, loop = FALSE, easing = CUBIC_EASING|EASE_OUT)
	addtimer(CALLBACK(src, PROC_REF(remove_glitchy_view)), glitch_undo_duration)


/datum/component/remote_control/proc/remove_glitchy_view(var/dont_set_timer = FALSE)
	var/mob/living/living_parent = parent
	var/atom/movable/plane_master_controller/game_plane_master_controller = living_parent.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.remove_filter("remote_control_glitch")
	if(!dont_set_timer)
		addtimer(CALLBACK(src, PROC_REF(start_glitchy_view)), rand(glitchy_view_interval_min, glitchy_view_interval_max))

/**
 * Sends the mind of the temporary body back into their previous host
 * If the previous host is alive, we'll force them into the body.
 * Otherwise we'll let them hang out as a ghost still.
 */
/datum/component/remote_control/proc/return_mind_to_controller()
	SIGNAL_HANDLER
	var/datum/mind/controller_mind = controller_mind_ref?.resolve()
	var/mob/living/controller_body = controller_body_ref?.resolve() || controller_mind.current
	var/mob/living/controlled_body = parent

	if(!controlled_body)
		return

	if(!controller_mind)
		return

	controlled_body.clear_fullscreen("static_noise")
	controlled_body.client?.close_popup("remote_control")

	if(controller_body?.stat != DEAD)
		controller_mind.transfer_to(controller_body, force_key_move = TRUE)
	else
		controller_mind.set_current(controller_body)

	if(controller_body)
		REMOVE_TRAIT(controller_body, TRAIT_MIND_TEMPORARILY_GONE, REF(src))

	controller_mind = null
	controller_body = null

	QDEL_NULL(controller_view)
	QDEL_NULL(tracker)



	remove_glitchy_view(dont_set_timer = TRUE)

	if(!QDELETED(end_remote_control))
		end_remote_control.Remove(controlled_body)
		QDEL_NULL(end_remote_control)
	if(!QDELETED(src))
		qdel(src)

///Creates a popup with the view around the controller.
/datum/component/remote_control/proc/show_controller_view()
	var/mob/living/controlled_mob = parent
	controlled_mob.client.setup_popup("remote_control", cam_range*2+1, cam_range*2+1, 2, "Spatial awareness view")
	controller_view.display_to(controlled_mob)
	update_view()


/datum/component/remote_control/proc/update_view()//this doesn't do anything too crazy, just updates the vis_contents of its screen obj
	controller_view.vis_contents.Cut()
	for(var/turf/visible_turf in view(cam_range, get_turf(controller_body_ref.resolve())))
		controller_view.vis_contents += visible_turf

/datum/component/remote_control/proc/on_popup_clear(client/source, window)
	SIGNAL_HANDLER
	if (window == "remote_control_map")
		var/mob/living/controlled_mob = parent
		UnregisterSignal(controlled_mob, COMSIG_POPUP_CLEARED)
		controller_view.hide_from(controlled_mob)

///Action to end control early
/datum/action/cooldown/end_remote_control
	name = "End Remote Control"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	desc = "Allows you to end remote control of the current mob."
	cooldown_time = 0 SECONDS

/datum/action/cooldown/end_remote_control/Activate(atom/target_atom)
	qdel(owner.GetComponent(/datum/component/remote_control))
	return TRUE
