GLOBAL_LIST_EMPTY(string_list_of_assoc_lists)

/**
 * Caches a flat list of associative lists, where each inner list has non-numeric stringify-able keys and values.
 *
 * Use this to canonicalize a list-of-assoc-lists into a stable reference suitable for ELEMENT_BESPOKE deduplication.
 * Inner lists are keyed via [/proc/string_assoc_list_key]; the outer list is keyed by joining inner keys with "|".
 */
/proc/string_list_of_assoc_lists(list/entries)
	var/list/string_id = list()
	for(var/list/inner as anything in entries)
		string_id += string_assoc_list_key(inner)
	string_id = string_id.Join("|")

	. = GLOB.string_list_of_assoc_lists[string_id]

	if(.)
		return .

	return GLOB.string_list_of_assoc_lists[string_id] = entries
