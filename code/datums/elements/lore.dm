/**
 * Attaches skill-gated lore to any atom.
 *
 * Each entry in the list is an assoc list with the following keys:
 * * "skill"     — (optional) A /datum/skill/lore subtype path. If null, any user qualifies.
 * * "min_level" — The minimum SKILL_LEVEL_* required. Defaults to SKILL_LEVEL_HORRIBLE (always qualifies).
 * * "desc"      — The lore text. Required.
 * * "name"      — (optional) An alternate name for the atom shown in examine and screentips.
 * * "article"   — (optional) Article used with the name in examine (e.g. "a", "an", "the"). Screentips use the bare name.
 * * "show_real_name" — (optional) If TRUE, appends a line telling the user what a layman would call this atom (i.e. its normal name).
 *
 * When examined, the entry with the highest min_level that the user qualifies for wins.
 *
 * Two display modes, controlled by `show_only_on_examine_more`:
 * * TRUE  (default): the atom's desc is left intact; lore text is appended in [/atom/proc/examine_more].
 *                    Qualified users see a "look closer" hint on normal examine.
 *                    Unqualified users see "there seems to be more..." unless is_secret is TRUE.
 * * FALSE: lore text replaces the atom's desc entirely for qualified users (via COMSIG_ATOM_EXAMINE_LORE).
 *          Unqualified users see "there seems to be more..." unless is_secret is TRUE.
 *
 * Wrap your entries list with [/proc/string_list_of_assoc_lists] so that atoms sharing identical
 * lore configurations share a single element instance (ELEMENT_BESPOKE deduplication).
 *
 * Example:
 * ```
 * AddElement(/datum/element/lore, string_list_of_assoc_lists(list(
 *     list("skill" = /datum/skill/lore/human, "min_level" = SKILL_LEVEL_NORMAL, "desc" = "..."),
 *     list("skill" = /datum/skill/lore/human, "min_level" = SKILL_LEVEL_EXPERT,  "name" = "Prototype X", "desc" = "..."),
 * )))
 * ```
 */
/datum/element/lore
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 2
	/// List of assoc lists, each describing one lore entry. See type header for keys.
	var/list/entries
	/// If TRUE, unqualified users see no hint that lore exists on this atom.
	var/is_secret
	/// If TRUE, lore is shown in examine_more (leaving the atom's desc intact).
	/// If FALSE, lore replaces the atom's desc for qualified users via COMSIG_ATOM_EXAMINE_LORE.
	var/show_only_on_examine_more

/datum/element/lore/Attach(datum/target, list/entries, is_secret = FALSE, show_only_on_examine_more = TRUE)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	if(!length(entries))
		CRASH("[type] attached to [target] with an empty entries list.")

	src.entries = string_list_of_assoc_lists(entries)
	src.is_secret = is_secret
	src.show_only_on_examine_more = show_only_on_examine_more

	if(show_only_on_examine_more)
		RegisterSignal(target, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_examine_more))
	else
		RegisterSignal(target, COMSIG_ATOM_EXAMINE_LORE, PROC_REF(on_examine_lore))
	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target, COMSIG_ATOM_GET_EXAMINE_NAME, PROC_REF(on_get_examine_name))
	RegisterSignal(target, COMSIG_ATOM_SCREENTIP_NAME_REQUESTED, PROC_REF(on_screentip_name))

/datum/element/lore/Detach(datum/source, ...)
	if(show_only_on_examine_more)
		UnregisterSignal(source, list(COMSIG_ATOM_EXAMINE_MORE, COMSIG_ATOM_EXAMINE, COMSIG_ATOM_GET_EXAMINE_NAME, COMSIG_ATOM_SCREENTIP_NAME_REQUESTED))
	else
		UnregisterSignal(source, list(COMSIG_ATOM_EXAMINE_LORE, COMSIG_ATOM_EXAMINE, COMSIG_ATOM_GET_EXAMINE_NAME, COMSIG_ATOM_SCREENTIP_NAME_REQUESTED))
	return ..()

/**
 * Returns the highest-min_level entry that the user qualifies for, or null if none.
 * An entry qualifies if it has no skill requirement, or the user's skill level meets min_level.
 */
/datum/element/lore/proc/find_best(mob/user)
	var/list/best
	var/best_level = -1
	for(var/list/entry as anything in entries)
		var/required_skill = entry["skill"]
		var/min_level = entry["min_level"] || SKILL_LEVEL_HORRIBLE
		if(min_level <= best_level)
			continue
		if(!required_skill || (user.mind?.get_skill_level(required_skill) >= min_level))
			best = entry
			best_level = min_level
	return best

/// Fires from COMSIG_ATOM_EXAMINE_LORE (show_only_on_examine_more = FALSE only).
/// Populates the lore list to override the atom's desc for qualified users.
/datum/element/lore/proc/on_examine_lore(atom/source, mob/user, list/lore)
	SIGNAL_HANDLER
	var/list/winner = find_best(user)
	if(!winner)
		return
	if(winner["show_real_name"])
		lore += span_notice("A layman would call this [source.name].")
	lore += "<i>[winner["desc"]]</i>"

/// Fires from COMSIG_ATOM_EXAMINE_MORE (show_only_on_examine_more = TRUE only).
/// Appends lore text for qualified users without disturbing the atom's normal desc.
/datum/element/lore/proc/on_examine_more(atom/source, mob/user, list/examine_more_list)
	SIGNAL_HANDLER
	var/list/winner = find_best(user)
	if(!winner)
		return
	if(winner["show_real_name"])
		examine_more_list += span_notice("A layman would call this [source.name].")
	examine_more_list += "<i>[winner["desc"]]</i>"

/**
 * Fires from COMSIG_ATOM_EXAMINE (both modes).
 *
 * In examine_more mode: qualified users get a "look closer" prompt;
 *   unqualified users get a vague hint (unless is_secret).
 * In desc-override mode: unqualified users only get the vague hint (unless is_secret).
 */
/datum/element/lore/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/qualified = !!find_best(user)
	if(show_only_on_examine_more)
		if(qualified)
			examine_list += span_notice("You can [EXAMINE_HINT("look closer")] to learn a little more about [source].")
		else if(!is_secret)
			examine_list += span_notice("There seems to be more to [source] than meets the eye, but you can't quite place it.")
	else
		if(!qualified && !is_secret)
			examine_list += span_notice("There seems to be more to [source] than meets the eye, but you can't quite place it.")

/// Fires from COMSIG_ATOM_GET_EXAMINE_NAME. Overrides the italic name in examine output if the user's best entry has a "name" key.
/datum/element/lore/proc/on_get_examine_name(atom/source, mob/user, list/override)
	SIGNAL_HANDLER
	var/list/winner = find_best(user)
	if(!winner?["name"])
		return
	override[EXAMINE_POSITION_NAME] = "<em>[winner["name"]]</em>"
	if(winner["article"])
		override[EXAMINE_POSITION_ARTICLE] = winner["article"]

/// Fires from COMSIG_ATOM_SCREENTIP_NAME_REQUESTED. Overrides the screentip name if the user's best entry has a "name" key.
/datum/element/lore/proc/on_screentip_name(atom/source, list/returned_name, obj/item/held_item, mob/user)
	SIGNAL_HANDLER
	var/list/winner = find_best(user)
	if(!winner?["name"])
		return
	returned_name[1] = winner["name"]
	return SCREENTIP_NAME_SET
