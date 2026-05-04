/// Assoc list of place of birth id strings to their datum instances. Populated at startup from all /datum/place_of_birth subtypes.
GLOBAL_LIST_INIT(place_of_birth_list, init_place_of_birth_list())

/proc/init_place_of_birth_list()
	var/list/pob_list = list()
	for(var/pob_type in subtypesof(/datum/place_of_birth))
		var/datum/place_of_birth/inst = new pob_type()
		pob_list[inst.id] = inst
	return pob_list
