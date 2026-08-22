// -------------------- METAL TILES --------------------

/turf/open/floor/steel_tile
	name = "steel floor"
	desc = "Stainless steel panels line the floor. They still seem quite bright and shiny after all these years."

	icon = 'icons/turf/floors/donkfloors/donktiles.dmi'
	icon_state = "steel_tile"
	base_icon_state = "steel_tile"

	rust_resistance = RUST_RESISTANCE_REINFORCED
	floor_tile = /obj/item/stack/tile/steel

/turf/open/floor/steel_tile/random
	var/static/list/steel_variants = list(
		"steel_tile" = 71,
		"steel_tile-loose" = 8,
		"steel_tile-greeble" = 2,
		"steel_tile-greeble-2" = 2,
		"steel_tile-greeble-3" = 2,
		"steel_tile-greeble-4" = 2,
		"steel_tile-greeble-5" = 2,
		"steel_tile-bullet" = 2,
		"steel_tile-bullet-2" = 2,
		"steel_tile-bullet-3" = 2,
		"steel_tile-bullet-4" = 2,
		"steel_tile-corrosion" = 2,
		"steel_tile-bird" = 1,
	)

/turf/open/floor/steel_tile/random/Initialize(mapload)
	. = ..()
	if(icon_state != base_icon_state) //if map edited don't change sprite.
		return
	icon_state = pick_weight(steel_variants)

/turf/open/floor/steel_tile/bullet
	var/static/list/swiss_variants = list(
		"steel_tile-bullet" = 25,
		"steel_tile-bullet-2" = 25,
		"steel_tile-bullet-3" = 25,
		"steel_tile-bullet-4" = 25,
	)

/turf/open/floor/steel_tile/bullet/Initialize(mapload)
	. = ..()
	if(icon_state != base_icon_state)
		return
	icon_state = pick_weight(swiss_variants)


/turf/open/floor/steel_tile/greebled
	var/static/list/greebled_variants = list(
		"steel_tile-greeble" = 20,
		"steel_tile-greeble-2" = 20,
		"steel_tile-greeble-3" = 20,
		"steel_tile-greeble-4" = 20,
		"steel_tile-greeble-5" = 20,
	)

/turf/open/floor/steel_tile/greebled/Initialize(mapload)
	. = ..()
	if(icon_state != base_icon_state)
		return
	icon_state = pick_weight(greebled_variants)

/turf/open/floor/iron_tile
	name = "floor"
	icon = 'icons/turf/floors/donkfloors/donktiles.dmi'
	icon_state = "iron_tile"
	floor_tile = /obj/item/stack/tile/iron/base
	rust_resistance = RUST_RESISTANCE_BASIC

/turf/open/floor/iron_tile/corroded
	name = "corroded floor"
	desc = "These floor tiles look dull and tired."
	icon_state = "iron_corroded_tile"
	base_icon_state = "iron_corroded_tile"
	floor_tile = /obj/item/stack/tile/iron/base //replace with corroded variant at some point

/turf/open/floor/iron_tile/rusty
	name = "rusty floor"
	desc = "Ordinary floor tiles, though these are slowly succumbing to the grinding teeth of entropy."

	icon_state = "iron_rusted_tile"
	base_icon_state = "iron_rusted_tile"

	floor_tile = /obj/item/stack/tile/iron/base //replace with rusty variant at some point
	var/static/list/rusty_variants = list(
		"iron_rusted_tile",
		"iron_rusted_tile-2",
		"iron_rusted_tile-3",
		"iron_rusted_tile-4",
		"iron_rusted_tile-5",
		"iron_rusted_tile-6",
		"iron_rusted_tile-7",
		"iron_rusted_tile-8",
		"iron_rusted_tile-9",
		"iron_rusted_tile-10",
		"iron_rusted_tile-11",
		"iron_rusted_tile-12",
		"iron_rusted_tile-13",
		"iron_rusted_tile-14",
		)

/turf/open/floor/iron_tile/rusty/Initialize(mapload)
	. = ..()
	if(icon_state != base_icon_state) //if map edited don't change sprite.
		return
	icon_state = pick(rusty_variants)

/turf/open/floor/plastitanium_tile
	name = "suspicious floor"
	desc = "Plastitanium flooring? Seems like that would be way too expensive, what is really going on here?"

	icon = 'icons/turf/floors/donkfloors/donktiles.dmi'
	icon_state = "plastitanium_tile"
	base_icon_state = "plastitanium_tile"

	floor_tile = /obj/item/stack/tile/plastitanium
	rust_resistance = RUST_RESISTANCE_TITANIUM

/turf/open/floor/plastitanium_tile/large
	icon_state = "plastitanium_tile-large"

/turf/open/floor/plastitanium_tile/textured
	icon_state = "plastitanium_tile-textured"

/turf/open/floor/plastitanium_tile/ribbed
	icon_state = "plastitanium_tile-ribbed"

/turf/open/floor/plastitanium_tile/hose
	icon_state = "plastitanium_tile-hose"

/turf/open/floor/plastitanium_tile/scale
	name = "plastitanium scales"
	desc = "Black scales line the floor.\nFeels primal, you almost expect it start moving beneath your feet."

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_PLASTITANIUM_SCALE + SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_OPEN_FLOOR
	canSmoothWith = SMOOTH_GROUP_PLASTITANIUM_SCALE

	icon = 'icons/turf/floors/donkfloors/plastitanium_scales.dmi'
	icon_state = "plastitanium_scales-0"
	base_icon_state = "plastitanium_scales"

	floor_tile = /obj/item/stack/tile/plastitanium/scale

/turf/open/floor/plastitanium_tile/tracks
	name = "plastitanium tracks"
	desc = "These tiles have sunken channels containing a set of smooth metal tracks."

	smoothing_flags = SMOOTH_BITMASK_CARDINALS
	smoothing_groups = SMOOTH_GROUP_PLASTITANIUM_TRACKS + SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_OPEN_FLOOR
	canSmoothWith = SMOOTH_GROUP_PLASTITANIUM_TRACKS

	icon = 'icons/turf/floors/donkfloors/plastitanium_tracks.dmi'
	icon_state = "plastitanium_tracks-15"
	base_icon_state = "plastitanium_tracks"



// -------------------- STONE AND CERAMIC TILES --------------------


/turf/open/floor/cool_tile
	name = "tile floor"
	icon = 'icons/turf/floors/donkfloors/donktiles.dmi'

	desc = "A floor made of white ceramic tiles. Easy to keep hygenic."
	icon_state = "cool_tile"
	floor_tile = /obj/item/stack/tile/cool

/turf/open/floor/brick
	name = "brick floor"
	desc = "A floor made of bricks. Looks neatly laid out, compliments to the bricklayer."

	icon = 'icons/turf/floors/donkfloors/donktiles.dmi'
	icon_state = "bricks"

	floor_tile = /obj/item/stack/tile/brick
	footstep = FOOTSTEP_CONCRETE

/turf/open/floor/terracotta
	name = "terracotta floor"
	desc = "A floor made of glazed terracotta tiles.\n\nIt reminds you of that villa in the Italian countryside you've always dreamed of."

	icon = 'icons/turf/floors/donkfloors/donktiles.dmi'
	icon_state = "terracotta_tile"

	floor_tile = /obj/item/stack/tile/terracotta
	footstep = FOOTSTEP_CONCRETE

/turf/open/floor/marble
	name = "marble floor"
	desc = "A floor made of the finest Italian marble. Molto Bene!"

	icon = 'icons/turf/floors/donkfloors/donktiles.dmi'
	icon_state = "marble"

	floor_tile = /obj/item/stack/tile/marble
	footstep = FOOTSTEP_CONCRETE

	var/static/list/marble_variants = list(
		"marble",
		"marble-2",
	)

/turf/open/floor/marble/Initialize(mapload)
	. = ..()
	if(icon_state != base_icon_state) //if map edited don't change sprite.
		return
	icon_state = pick(marble_variants)


// -------------------- CONCRETE AND INDUSTRIAL TILES --------------------


/turf/open/floor/concrete/sludge_pool
	name = "sludge pool"
	desc = "A basin filled with industrial waste from the telecrystal manufacturing process.\n\nThe sludge is thought to be composed of a complex mixture of acids, solvents and heavy metals."

	icon = 'icons/turf/floors/donkfloors/sludge_pool.dmi'
	icon_state = "sludge_pool-0"
	base_icon_state = "sludge_pool"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SLUDGE_POOL + SMOOTH_GROUP_FLOOR_CONCRETE + SMOOTH_GROUP_TURF_OPEN
	canSmoothWith = SMOOTH_GROUP_SLUDGE_POOL

	overfloor_placed = FALSE
	footstep = FOOTSTEP_WATER

/turf/open/shaft_grating
	name = "shaft grating"
	desc = "A rugged grating used to traverse open shafts. Don't look down."

	icon = 'icons/turf/floors/donkfloors/shaft_grating.dmi'
	icon_state = "shaft_grating-0"
	base_icon_state = "shaft_grating"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SHAFT_GRATING + SMOOTH_GROUP_TURF_OPEN
	canSmoothWith = SMOOTH_GROUP_SHAFT_GRATING

	baseturfs = /turf/open/chasm/shaft

	footstep = FOOTSTEP_CATWALK

/turf/open/chasm/shaft
	name = "shaft"
	desc = "An open shaft. You try not to stare down into the gaping maw of the station."

	icon = 'icons/turf/floors/donkfloors/shaft.dmi'
	icon_state = "shaft-0"
	base_icon_state = "shaft"
	smoothing_groups = SMOOTH_GROUP_SHAFT + SMOOTH_GROUP_TURF_CHASM + SMOOTH_GROUP_TURF_OPEN
	canSmoothWith = SMOOTH_GROUP_SHAFT + SMOOTH_GROUP_TURF_CHASM

