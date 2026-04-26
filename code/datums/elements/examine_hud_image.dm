///Add this element to an atom to have the ability to show an extra icon when its double-examined. First examine shows examine_hint_text to indicate you can examine more for a detailed image. Image is removed  when mouseexit occurs.
/datum/element/examine_hud_image
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 2

	/// The icon file to display on the HUD
	var/hud_icon
	/// The icon state to display on the HUD
	var/hud_icon_state
	/// Horizontal pixel offset relative to the atom
	var/pixel_x_offset = 0
	/// Vertical pixel offset relative to the atom
	var/pixel_y_offset = 0
	/// Text shown on a normal examine to hint the player they can take a closer look.
	var/examine_hint_text = "It looks like you could take a closer look."
	/// Text shown alongside the image when examine_more is triggered.
	var/examine_more_text = "You notice some details on this thing..."
	/// Assoc list of mob -> list("appearance_ref" = weakref, "source_ref" = weakref), for active viewers
	var/list/active_viewers

/datum/element/examine_hud_image/Attach(datum/target, hud_icon, hud_icon_state, pixel_x = 0, pixel_y = 0, examine_hint_text, examine_more_text)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE

	src.hud_icon = hud_icon
	src.hud_icon_state = hud_icon_state
	src.pixel_x_offset = pixel_x
	src.pixel_y_offset = pixel_y
	if(!isnull(examine_hint_text))
		src.examine_hint_text = examine_hint_text
	if(!isnull(examine_more_text))
		src.examine_more_text = examine_more_text

	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_examine_more))

/datum/element/examine_hud_image/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, list(COMSIG_ATOM_EXAMINE, COMSIG_ATOM_EXAMINE_MORE))
	if(!active_viewers)
		return
	for(var/mob/user as anything in active_viewers)
		clear_viewer(source, user)

/datum/element/examine_hud_image/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_info(examine_hint_text)

/datum/element/examine_hud_image/proc/on_examine_more(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!user?.client)
		return

	clear_viewer(source, user) // Remove any existing appearance for this user first

	var/image/hud_image = image(hud_icon, source, hud_icon_state)
	hud_image.pixel_x = pixel_x_offset
	hud_image.pixel_y = pixel_y_offset
	SET_PLANE_EXPLICIT(hud_image, HUD_PLANE, source)
	hud_image.appearance_flags = RESET_COLOR | KEEP_APART

	var/unique_key = "examine_hud_[REF(src)]_[REF(user)]"
	var/datum/atom_hud/alternate_appearance/basic/one_person/appearance = source.add_alt_appearance(
		/datum/atom_hud/alternate_appearance/basic/one_person,
		unique_key,
		hud_image,
		NONE,
		user,
	)
	if(!appearance)
		return

	examine_list += span_notice(examine_more_text)
	LAZYINITLIST(active_viewers)
	active_viewers[user] = list("appearance_ref" = WEAKREF(appearance), "source_ref" = WEAKREF(source))

	RegisterSignal(user, COMSIG_ATOM_MOUSE_ENTERED, PROC_REF(on_viewer_mouse_entered))
	RegisterSignal(user, COMSIG_QDELETING, PROC_REF(on_viewer_deleted))

/datum/element/examine_hud_image/proc/clear_viewer(atom/source, mob/user)
	if(!active_viewers?[user])
		return
	UnregisterSignal(user, list(COMSIG_ATOM_MOUSE_ENTERED, COMSIG_QDELETING))
	var/list/viewer_data = active_viewers[user]
	active_viewers -= user

	var/datum/weakref/appearance_ref = viewer_data["appearance_ref"]
	if(appearance_ref)
		var/datum/atom_hud/alternate_appearance/appearance = appearance_ref.resolve()
		if(appearance)
			qdel(appearance)

///If the viewer moves their mouse to another atom, we exit. This is more reliable than using exit in case you double-examined but already fucked your mouse off.
/datum/element/examine_hud_image/proc/on_viewer_mouse_entered(mob/user, atom/hovered)
	SIGNAL_HANDLER
	var/list/viewer_data = active_viewers?[user]
	if(!viewer_data)
		return
	var/datum/weakref/source_ref = viewer_data["source_ref"]
	var/atom/source
	if(source_ref)
		source = source_ref.resolve()
	if(hovered == source)
		return // Still hovering the same atom, keep showing
	clear_viewer(source, user)

///sayonara, viewer.
/datum/element/examine_hud_image/proc/on_viewer_deleted(mob/user)
	SIGNAL_HANDLER
	var/list/viewer_data = active_viewers?[user]
	if(!viewer_data)
		return
	var/datum/weakref/source_ref = viewer_data["source_ref"]
	var/atom/source
	if(source_ref)
		source = source_ref.resolve()
	clear_viewer(source, user)
