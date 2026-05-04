/*!
This subsystem exists to manages character archetype datum singletons.
*/

SUBSYSTEM_DEF(characters)
	name = "Characters"
	flags = SS_NO_FIRE
	///Dictionary of archetype.type || archetype ref
	var/list/all_archetypes = list()

/datum/controller/subsystem/characters/Initialize()
	InitializeArchetypes()
	return SS_INIT_SUCCESS

///Ran on initialize, populates the archetype dictionary
/datum/controller/subsystem/characters/proc/InitializeArchetypes()
	for(var/type in subtypesof(/datum/character_archetype))
		var/datum/character_archetype/ref = new type
		all_archetypes[type] = ref
