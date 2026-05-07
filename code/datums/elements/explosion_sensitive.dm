///This marks an object as sensitive to nearby explosions, up to sensitivity radius. It doesn't do anything on its own, but lets you make use of the COMSIG_ATOM_SENSITIVE_NEARBY_EXPLOSION to have interesting behavior
/datum/element/explosion_sensitive
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/explosion_sensitive/Attach(atom/movable/parent, sensitivity_radius = 2)
	. = ..()
	if(!ismovable(parent))
		return ELEMENT_INCOMPATIBLE
	SSexplosions.sensitive_objects[parent] = sensitivity_radius

/datum/element/explosion_sensitive/Detach(atom/movable/source, ...)
	. = ..()
	SSexplosions.sensitive_objects -= source
