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
<<<<<<< HEAD
=======
	var/new_plane = OVER_FRILL_PLANE
	if(real_target.wall_mount_common_plane(newdir))
		new_plane = initial(real_target.plane)
	SET_PLANE_EXPLICIT(real_target, new_plane, real_target)
	real_target.layer = ON_WALL_LAYER
>>>>>>> 9cc72b5b68aba36399b6e74b23aab10d6d031a9d
	real_target.wall_mount_offset(newdir)
	real_target.update_appearance()

