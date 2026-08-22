#define HANGAR_ID "hangar"
#define HANGAR_BREAKROOM_ID "breakroom"

// Recon Radar
// Mainly serve as landing pad decoration, but fulfills a secondary function
/obj/machinery/recon_radar
	name = "Recon Outpost Radar"
	desc = "A steel benemoth towers over the recon outpost, keeping silent watch."

	icon = 'icons/obj/machines/donk_machines/big_machines_96x96.dmi'
	icon_state = "recon_radar"

	pixel_w = -32
	base_pixel_w = -32
	appearance_flags = LONG_GLIDE

	density = TRUE
	anchored = TRUE
	use_power = NO_POWER_USE
	circuit = null

	max_integrity = 500
	resistance_flags =  LAVA_PROOF | FIRE_PROOF | FREEZE_PROOF

/obj/machinery/recon_radar/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ROUND_ENDED, PROC_REF(on_round_end))

/obj/machinery/recon_radar/proc/on_round_end(datum/source)
	addtimer(CALLBACK(src, PROC_REF(open_shutters), HANGAR_ID), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(open_shutters), HANGAR_BREAKROOM_ID), 30 SECONDS)

/obj/machinery/recon_radar/proc/open_shutters(shutter_id)
	for(var/obj/machinery/door/poddoor/hangar_shutter as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door/poddoor))
		if(hangar_shutter.id != shutter_id)
			continue
		hangar_shutter.open()

#undef HANGAR_ID
#undef HANGAR_BREAKROOM_ID
