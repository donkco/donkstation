/datum/element/wall_mount

/datum/element/wall_mount/Attach(datum/target)
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE
	. = ..()
	var/atom/movable/real_target = target
	RegisterSignal(target, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_changed))
	on_dir_changed(real_target, real_target.dir, real_target.dir)

/datum/element/wall_mount/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, COMSIG_ATOM_DIR_CHANGE)

/datum/element/wall_mount/proc/on_dir_changed(datum/target, olddir, newdir)
	var/atom/movable/real_target = target
	real_target.wall_mount_offset(newdir)
	real_target.update_appearance()

