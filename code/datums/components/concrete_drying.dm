/**
 * Shared drying component for wet concrete turfs and concrete moulds.
 *
 * Attach to a wet concrete turf or a concrete mould structure.
 * Dispatches on `dry_result` type: if it's a turf path, calls ChangeTurf;
 * if it's an obj path, spawns the new obj and qdels the parent.
 */
/datum/component/concrete_drying
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	/// The type to transform/spawn when drying completes
	var/dry_result
	/// Time in deciseconds before drying completes
	var/dry_time = 3 MINUTES
	/// Stored timer ID so we can cancel on early removal
	var/timer_id

/datum/component/concrete_drying/Initialize(path, time = 3 MINUTES)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	dry_result = path
	dry_time = time
	timer_id = addtimer(CALLBACK(src, PROC_REF(finish_drying)), dry_time, TIMER_DELETE_ME)

/datum/component/concrete_drying/RegisterWithParent()
	RegisterSignal(parent, COMSIG_CONCRETE_WET_SCOOPED, PROC_REF(on_scooped))

/datum/component/concrete_drying/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_CONCRETE_WET_SCOOPED)

/datum/component/concrete_drying/InheritComponent(datum/newcomp, original, path, time)
	// Restart the timer if re-applied (e.g. for concrete moulds receiving additional units)
	if(timer_id)
		deltimer(timer_id)
	timer_id = addtimer(CALLBACK(src, PROC_REF(finish_drying)), dry_time, TIMER_DELETE_ME)

/datum/component/concrete_drying/Destroy()
	if(timer_id)
		deltimer(timer_id)
		timer_id = null
	return ..()

/// Cancels drying when the wet concrete turf is scooped by a shovel.
/datum/component/concrete_drying/proc/on_scooped(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/concrete_drying/proc/finish_drying()
	INVOKE_ASYNC(src, PROC_REF(_do_finish))

/datum/component/concrete_drying/proc/_do_finish()
	timer_id = null
	if(ispath(dry_result, /turf))
		var/turf/open/floor/concrete/wet/T = parent
		if(istype(T))
			// Capture footprints before ChangeTurf resets vars, then restore them on the new turf.
			var/has_footprints = (T.leave_footprints || T.can_have_footprints) && (T.footprint_entrance_dirs || T.footprint_exit_dirs)
			var/saved_entrance = T.footprint_entrance_dirs
			var/saved_exit = T.footprint_exit_dirs
			var/list/saved_shoes = T.footprint_shoe_types ? T.footprint_shoe_types.Copy() : null
			var/list/saved_species = T.footprint_species_types ? T.footprint_species_types.Copy() : null
			T.ChangeTurf(dry_result, null, CHANGETURF_INHERIT_AIR)
			if(has_footprints)
				var/turf/open/dry = T // same reference, now dry type
				dry.footprint_entrance_dirs = saved_entrance
				dry.footprint_exit_dirs = saved_exit
				dry.footprint_shoe_types = saved_shoes
				dry.footprint_species_types = saved_species
				dry.update_appearance()
	else
		var/atom/A = parent
		if(!QDELETED(A))
			var/spawn_dir = A.dir
			var/atom/movable/spawned = new dry_result(get_turf(A))
			if(spawned)
				spawned.setDir(spawn_dir)
			qdel(A)
