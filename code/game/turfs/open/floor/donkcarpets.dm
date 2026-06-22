// No smoothing version of carpet
/turf/open/floor/carpet/borderless
	desc = "A modern tufted carpet. Fit for any corporate office."

	icon = 'icons/turf/floors/donkfloors/donkcarpets.dmi'
	icon_state = "carpet_bars"
	base_icon_state = "carpet_bars"
	smoothing_flags = null
	smoothing_groups = null
	canSmoothWith = null
	floor_tile = /obj/item/stack/tile/carpet/borderless

/turf/open/floor/carpet/borderless/zigzag
	icon_state = "carpet_zigzag"
	base_icon_state = "carpet_zigzag"

	floor_tile = /obj/item/stack/tile/carpet/borderless/zigzag

/turf/open/floor/carpet/borderless/cream
	icon_state = "carpet_cream"
	base_icon_state = "carpet_cream"

	floor_tile = /obj/item/stack/tile/carpet/borderless/cream

/turf/open/floor/carpet/borderless/grey
	icon_state = "carpet_grey"
	base_icon_state = "carpet_grey"

	floor_tile = /obj/item/stack/tile/carpet/borderless/grey

/turf/open/floor/carpet/borderless/teal
	icon_state = "carpet_teal"
	base_icon_state = "carpet_teal"

	floor_tile = /obj/item/stack/tile/carpet/borderless/teal

/turf/open/floor/carpet/borderless/orange
	icon_state = "carpet_orange"
	base_icon_state = "carpet_orange"

	floor_tile = /obj/item/stack/tile/carpet/borderless/orange

/turf/open/floor/carpet/borderless/avocado
	icon_state = "carpet_avocado"
	base_icon_state = "carpet_avocado"

	floor_tile = /obj/item/stack/tile/carpet/borderless/avocado

/turf/open/floor/carpet/borderless/mustard
	icon_state = "carpet_mustard"
	base_icon_state = "carpet_mustard"

	floor_tile = /obj/item/stack/tile/carpet/borderless/mustard

/turf/open/floor/carpet/borderless/red
	icon_state = "carpet_red"
	base_icon_state = "carpet_red"

	floor_tile = /obj/item/stack/tile/carpet/borderless/red

/turf/open/floor/carpet/sus
	name = "really suspicious carpet"
	desc = "The striking red and black pattern seems familiar... Could this be indicative of syndicate activity?"

	icon = 'icons/turf/floors/donkfloors/carpet_really_sus.dmi'
	icon_state = "carpet_really_sus-0"
	base_icon_state = "carpet_really_sus"
	smoothing_groups = SMOOTH_GROUP_SUS_CARPET + SMOOTH_GROUP_TURF_OPEN
	canSmoothWith = SMOOTH_GROUP_SUS_CARPET

	floor_tile = /obj/item/stack/tile/carpet/sus
