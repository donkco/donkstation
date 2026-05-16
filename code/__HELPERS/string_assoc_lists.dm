GLOBAL_LIST_EMPTY(string_assoc_lists)

/// Returns a cache key string for a flat assoc list of stringify-able keys and values.
/proc/string_assoc_list_key(list/values)
	var/list/string_id = list()
	for(var/val in values)
		string_id += "[val]_[values[val]]"
	return string_id.Join("-")

/**
 * Caches associative lists with non-numeric stringify-able index keys and stringify-able values (text/typepath -> text/path/number).
 */
/datum/proc/string_assoc_list(list/values)
	var/string_id = string_assoc_list_key(values)

	if(!length(GLOB.string_assoc_lists)) // because we might be accessing this super early in some cases, it might not be set up yet!
		GLOB.string_assoc_lists = list() // so do that now.

	. = GLOB.string_assoc_lists[string_id]

	if(.)
		return .

	return GLOB.string_assoc_lists[string_id] = values
