//Marks an atom as appearing in the target list of a crypto-chipped crew pinpointer.
/datum/element/trackable
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 2
	/// Unique identifier string used as the key in GLOB.trackable_atoms. This allows us to transfer the tracking which is useful for stickers which move from atom-to-atom
	var/tracking_id
	/// Display name shown in the pinpointer target list.
	var/track_name

/datum/element/trackable/Attach(datum/target, new_tracking_id, new_track_name)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE || !isatom(target))
		return
	tracking_id = new_tracking_id
	track_name = new_track_name
	GLOB.trackable_atoms[tracking_id] = target
	GLOB.trackable_names[tracking_id] = track_name

/datum/element/trackable/Detach(datum/source, ...)
	GLOB.trackable_atoms -= tracking_id
	GLOB.trackable_names -= tracking_id
	return ..()
