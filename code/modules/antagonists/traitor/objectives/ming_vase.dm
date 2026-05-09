/**
 * ## Ming Vase Destroy Objective
 *
 * Primary goal: Destroy the Priceless Ming Vase.
 * Secondary goal: Exfiltrate it intact to DonkCom. (Also counts as a win.)
 */
/datum/objective/destroy_ming_vase
	name = "destroy ming vase"
	explanation_text = "Destroy the Priceless Ming Vase. Smash it, blow it up, or shatter this irreplaceable relic by any means."
	secondary_explanation_text = "Exfiltrating the Priceless Ming Vase intact to DonkCom would be even better."
	secondary_also_wins = TRUE
	admin_grantable = TRUE

/// Primary: all vases are gone, or none remain unprotected on the station.
/datum/objective/destroy_ming_vase/check_completion()
	if(!length(GLOB.ming_vases))
		return TRUE
	for(var/obj/item/vase/ming/vase in GLOB.ming_vases)
		var/turf/T = get_turf(vase)
		if(T && !T.onCentCom())
			return FALSE // At least one vase still intact on-station
	return FALSE // All remaining vases are on CentCom — that's the secondary win

/// Secondary: at least one vase exists and is on CentCom (exfiltrated intact).
/datum/objective/destroy_ming_vase/check_secondary_completion()
	for(var/obj/item/vase/ming/vase in GLOB.ming_vases)
		var/turf/T = get_turf(vase)
		if(T && T.onCentCom())
			return TRUE
	return FALSE

///Just a fancy table. >:)
/obj/structure/table/pedestal
	name = "Ming Vase Pedestal"
	desc = "A fancy wooden pedestal. A small placard reads: 'Priceless Ming Vase — Do Not Touch.'"
	icon = 'icons/obj/mingvase.dmi'
	icon_state = "pedestal"
	can_flip = FALSE
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null
