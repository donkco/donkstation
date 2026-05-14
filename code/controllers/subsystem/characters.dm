/*!
This subsystem exists to manages character archetype datum singletons.
*/

SUBSYSTEM_DEF(characters)
	name = "Characters"
	ss_flags = SS_NO_FIRE
	///Dictionary of archetype.type || archetype ref
	var/list/all_archetypes = list()
	/// Dictionary of archetype_id string -> archetype ref for fast lookup.
	var/list/archetypes_by_id = list()

/datum/controller/subsystem/characters/Initialize()
	InitializeArchetypes()
	return SS_INIT_SUCCESS

///Ran on initialize, populates the archetype dictionary
/datum/controller/subsystem/characters/proc/InitializeArchetypes()
	for(var/type in subtypesof(/datum/character_archetype))
		var/datum/character_archetype/ref = new type
		all_archetypes[type] = ref
		if(ref.archetype_id)
			archetypes_by_id[ref.archetype_id] = ref

/// Returns the archetype singleton whose archetype_id matches the given string, or null.
/datum/controller/subsystem/characters/proc/get_archetype_by_id(archetype_id_str)
	return archetypes_by_id[archetype_id_str]
