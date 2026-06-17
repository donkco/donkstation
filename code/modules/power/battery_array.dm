/obj/item/stock_parts/power_store/battery_array
	name = "battery array"
	desc = "Many batteries, working together towards a common goal, just like our proud syndicate!"

	icon = 'icons/obj/donk_parts.dmi'
	icon_state = "array"
	charge_light_type = null

	maxcharge = 0
	/// List of battery objects contained withing the cells
	var/list/obj/item/stock_parts/power_store/cell/tenant_cells = list()
	/// list of cell typepaths for what cells the array should start with.
	var/list/obj/item/stock_parts/power_store/cell/starting_cells = list()
	/// how many cells can we hold
	var/max_cells = 2
	//Max cell size
	var/max_cell_size = CELL_SIZE_AA
	var/vector/array_offset = vector(2,0)
	var/overlay_variant_num = 0
	var/flip_alternating = TRUE

	var/vector/overlay_base_pixel = vector(14, 14)

/obj/item/stock_parts/power_store/battery_array/Initialize(mapload, override_maxcharge)
	. = ..()
	for(var/cell_blueprint in starting_cells)
		add_cell(new cell_blueprint(src), FALSE)
	update_appearance()

/// Adds a cell to the battery array, returning true if it can be added, false if not
/obj/item/stock_parts/power_store/battery_array/proc/add_cell(obj/item/stock_parts/power_store/cell/new_tenant, update_overlays = TRUE)
	if(new_tenant.cell_size > max_cell_size)
		return FALSE
	if(tenant_cells.len >= max_cells)
		return FALSE
	tenant_cells += new_tenant
	if(new_tenant.loc != src)
		new_tenant.forceMove(src) //get in here
	if(update_overlays) //save some cpu cycles on mass adding cells by not making redundant aooearance stuff.
		update_appearance()
	return TRUE

/obj/item/stock_parts/power_store/battery_array/proc/remove_cell(obj/item/stock_parts/power_store/cell/evicted_tenant)
	tenant_cells -= evicted_tenant
	update_appearance()

/obj/item/stock_parts/power_store/battery_array/get_cell()
	return tenant_cells.len ? tenant_cells[1] : src

/obj/item/stock_parts/power_store/battery_array/Exited(gone)
	. = ..()
	if(gone in tenant_cells)
		remove_cell(gone)

/obj/item/stock_parts/power_store/battery_array/max_charge()
	var/total_maxcharge = 0
	for(var/obj/item/stock_parts/power_store/tenant in tenant_cells)
		total_maxcharge += tenant.max_charge()
	return total_maxcharge

/obj/item/stock_parts/power_store/battery_array/charge()
	var/total_charge = 0
	for(var/obj/item/stock_parts/power_store/tenant in tenant_cells)
		total_charge += tenant.charge()
	return total_charge

/obj/item/stock_parts/power_store/battery_array/get_chargerate()
	var/total_chargerate = 0
	for(var/obj/item/stock_parts/power_store/tenant in tenant_cells)
		total_chargerate += tenant.get_chargerate()
	return total_chargerate

/obj/item/stock_parts/power_store/battery_array/is_corrupted()
	for(var/obj/item/stock_parts/power_store/tenant in tenant_cells)
		if(tenant.is_corrupted())
			return TRUE
	return FALSE

/obj/item/stock_parts/power_store/battery_array/use(used, force = FALSE)
	var/initial_charge = charge()
	if(initial_charge <= 0 JOULES)
		return 0
	var/power_used = 0
	for(var/obj/item/stock_parts/power_store/tenant in tenant_cells)
		if(!tenant.charge()) //no division by zero.
			continue
		power_used += tenant.use(tenant.charge() / initial_charge * min(used, initial_charge), force)
	return power_used

/obj/item/stock_parts/power_store/battery_array/give(amount)
	var/initial_capacity = used_charge()
	if(initial_capacity <= 0 JOULES)
		return 0
	var/power_used = 0
	for(var/obj/item/stock_parts/power_store/tenant in tenant_cells)
		power_used += tenant.give(tenant.used_charge() / initial_capacity * min(amount, initial_capacity))
	return power_used

/obj/item/stock_parts/power_store/battery_array/change(amount)
	if(amount >= 0 JOULES)
		return give(amount)
	else
		return -use(amount)

/obj/item/stock_parts/power_store/battery_array/corrupt(force)
	for(var/obj/item/stock_parts/power_store/tenant in tenant_cells)
		tenant.corrupt(force)

/obj/item/stock_parts/power_store/battery_array/set_maxcharge(amount)
	var/initial_maxcharge = max_charge()
	for(var/obj/item/stock_parts/power_store/tenant in tenant_cells)
		tenant.set_maxcharge(tenant.max_charge() / initial_maxcharge * amount)

/obj/item/stock_parts/power_store/battery_array/set_charge(amount)
	for(var/obj/item/stock_parts/power_store/tenant in tenant_cells)
		tenant.set_charge(tenant.max_charge() / max_charge() * amount)

/obj/item/stock_parts/power_store/battery_array/set_chargerate(amount)
	var/charge_mod = 0
	if(amount) // No div by zero
		charge_mod = get_chargerate() / amount
	for(var/obj/item/stock_parts/power_store/tenant in tenant_cells)
		tenant.set_chargerate(tenant.get_chargerate() * charge_mod)

/obj/item/stock_parts/power_store/battery_array/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(W, /obj/item/stock_parts/power_store))
		var/obj/item/stock_parts/power_store/loose_cell = W
		if(add_cell(loose_cell))
			playsound(src, 'sound/items/pen_click.ogg', 60, TRUE)
			return
		to_chat(user, span_notice("That won't fit in [src]."))
	else
		return ..()

/obj/item/stock_parts/power_store/battery_array/attack_self(mob/user)
	if(!tenant_cells.len)
		return ..()
	var/atom/movable/removed_cell = get_cell()
	removed_cell.forceMove(drop_location())
	user.put_in_hands(removed_cell)
	playsound(src, 'sound/items/click.ogg', 100, TRUE)

/obj/item/stock_parts/power_store/battery_array/update_overlays()
	. = ..()
	if(!tenant_cells.len)
		return
	var/vector/battery_offset = vector(0,0)

	var/state_suffix = 0
	for(var/obj/item/stock_parts/power_store/tenant in tenant_cells)
		if(overlay_variant_num)
			state_suffix = rand(0, overlay_variant_num)

		var/mutable_appearance/tiny_overlay = mutable_appearance('icons/obj/donk_parts.dmi', "[tenant.tiny_state]_[state_suffix]")
		tiny_overlay.set_pixel_offset(battery_offset)
		. += tiny_overlay
		battery_offset += array_offset
		state_suffix = state_suffix ^ flip_alternating


/obj/item/stock_parts/power_store/battery_array/two_aaa
	max_cells = 2
	max_cell_size = CELL_SIZE_AAA
	tenant_cells = list(/obj/item/stock_parts/power_store/cell/aaa, /obj/item/stock_parts/power_store/cell/aaa)


/obj/item/stock_parts/power_store/battery_array/four_aaa
	max_cells = 4
	max_cell_size = CELL_SIZE_AAA
	starting_cells = list(
		/obj/item/stock_parts/power_store/cell/aaa,
		/obj/item/stock_parts/power_store/cell/aaa,
		/obj/item/stock_parts/power_store/cell/aaa,
		/obj/item/stock_parts/power_store/cell/aaa,
		)

/obj/item/stock_parts/power_store/battery_array/two_aa
	max_cells = 2
	max_cell_size = CELL_SIZE_AA
	starting_cells = list(/obj/item/stock_parts/power_store/cell/aa, /obj/item/stock_parts/power_store/cell/aa)

/obj/item/stock_parts/power_store/battery_array/two_aa_alkaline
	max_cells = 2
	max_cell_size = CELL_SIZE_AA
	starting_cells = list(/obj/item/stock_parts/power_store/cell/aa/alkaline, /obj/item/stock_parts/power_store/cell/aa/alkaline)

/obj/item/stock_parts/power_store/battery_array/four_aa
	max_cells = 4
	max_cell_size = CELL_SIZE_AA
	starting_cells = list(
		/obj/item/stock_parts/power_store/cell/aa,
		/obj/item/stock_parts/power_store/cell/aa,
		/obj/item/stock_parts/power_store/cell/aa,
		/obj/item/stock_parts/power_store/cell/aa,
		)

/obj/item/stock_parts/power_store/battery_array/double_d
	icon_state = "array-double_d"

	max_cells = 2
	max_cell_size = CELL_SIZE_D

	flip_alternating = FALSE
	overlay_variant_num = 3
	array_offset = vector(7,0)
	overlay_base_pixel = vector(12, 14)
	starting_cells = list(
		/obj/item/stock_parts/power_store/cell/d,
		/obj/item/stock_parts/power_store/cell/d,
		)

