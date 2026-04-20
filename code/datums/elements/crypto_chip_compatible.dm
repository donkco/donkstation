/**
 * # Crypto Chip Compatible Element
 *
 * Marks an object as accepting a [/obj/item/crypto_chip].
 * Only one chip may be inserted at a time. Insertion is done by left-clicking the host with a chip,
 * and removal is done by right-clicking the object with a soldering iron.
 *
 * When a chip is inserted or removed, [COMSIG_OBJ_ADDED_CRYPTO_CHIP] or [COMSIG_OBJ_REMOVED_CRYPTO_CHIP]
 * is sent on the host object respectively. You can register for this signal to perform any behavior you want.
 *
 * Per-object chip references are tracked in an assoc list on this singleton element,
 */
/datum/element/crypto_chip_compatible
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY
	/// Assoc list of (atom/host) -> (obj/item/crypto_chip). Tracks which chip is in which host. Doing it like this prevents us from having a gazillion components on each chippable thing
	var/list/host_chips


///start_with_chip lets you start with a chip installed, useful for objects that spawn with one.
/datum/element/crypto_chip_compatible/Attach(datum/target, start_with_chip = FALSE)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE)
		return
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE

	if(start_with_chip)
		insert_chip(target, new /obj/item/crypto_chip(target), null)

	RegisterSignal(target, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_item_interaction))
	RegisterSignal(target, COMSIG_ATOM_TOOL_ACT(TOOL_SOLDERING_IRON), PROC_REF(on_soldering_iron_act))

/datum/element/crypto_chip_compatible/Detach(datum/source, ...)
	UnregisterSignal(source, list(COMSIG_ATOM_ITEM_INTERACTION, COMSIG_ATOM_TOOL_ACT(TOOL_SOLDERING_IRON)))
	remove_chip(source, null)
	return ..()

/**
 * Registers [chip] as installed in [target], setting obj_flags and firing [COMSIG_OBJ_ADDED_CRYPTO_CHIP].
 * The caller is responsible for moving [chip] into [target] beforehand. [user] may be null.
 */
/datum/element/crypto_chip_compatible/proc/insert_chip(atom/target, obj/item/crypto_chip/chip, mob/living/user)
	LAZYSET(host_chips, target, chip)
	if(isobj(target))
		var/obj/obj_target = target
		obj_target.obj_flags |= CRYPTO_CHIPPED
	if(user)
		target.balloon_alert(user, "crypto chip attached!")
	SEND_SIGNAL(target, COMSIG_OBJ_ADDED_CRYPTO_CHIP, chip, user)

/**
 * Removes and returns the chip from [source], clearing obj_flags and firing [COMSIG_OBJ_REMOVED_CRYPTO_CHIP].
 * Returns null if no chip was found or the chip was already deleted. [user] may be null.
 */
/datum/element/crypto_chip_compatible/proc/remove_chip(atom/source, mob/living/user)
	var/obj/item/crypto_chip/chip = LAZYACCESS(host_chips, source)
	if(!chip)
		return null
	LAZYREMOVE(host_chips, source)
	if(isobj(source))
		var/obj/obj_source = source
		obj_source.obj_flags &= ~CRYPTO_CHIPPED
	if(QDELETED(chip))
		return null
	chip.forceMove(get_turf(source))
	if(user)
		source.balloon_alert(user, "crypto chip removed from object!")
	SEND_SIGNAL(source, COMSIG_OBJ_REMOVED_CRYPTO_CHIP, chip, user)
	return chip

/**
 * Signal handler for [COMSIG_ATOM_ITEM_INTERACTION].
 * Inserts a crypto chip into the host if it isn't already chipped.
 */
/datum/element/crypto_chip_compatible/proc/on_item_interaction(atom/source, mob/living/user, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER
	if(!istype(tool, /obj/item/crypto_chip))
		return NONE
	if(isobj(source))
		var/obj/obj_source = source
		if(obj_source.obj_flags & CRYPTO_CHIPPED)
			source.balloon_alert(user, "already has a chip!")
			return ITEM_INTERACT_BLOCKING
	tool.forceMove(source)
	insert_chip(source, tool, user)
	return ITEM_INTERACT_SUCCESS

/**
 * Signal handler for [COMSIG_ATOM_TOOL_ACT(TOOL_SOLDERING_IRON)].
 * Removes the crypto chip from the host when left-clicked with a soldering iron.
 */
/datum/element/crypto_chip_compatible/proc/on_soldering_iron_act(atom/source, mob/living/user, obj/item/tool)
	SIGNAL_HANDLER
	if(isobj(source))
		var/obj/obj_source = source
		if(!(obj_source.obj_flags & CRYPTO_CHIPPED))
			return NONE
	remove_chip(source, user)
	return ITEM_INTERACT_SUCCESS
