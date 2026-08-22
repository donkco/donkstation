
// --------------------------- DONK CO. OFFICE ------------------------------

/area/command/office
	name = "\improper Office"
	icon = 'icons/area/donk_area.dmi'
	icon_state = "office"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/command/executive_office
	name = "\improper Executive Office"
	icon = 'icons/area/donk_area.dmi'
	icon_state = "executive_office"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/command/heads_quarters/ex
	name = "\improper Executive Bedroom"
	icon = 'icons/area/donk_area.dmi'
	icon_state = "executive_quarters"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/command/heads_quarters/mss
	name = "\improper Secretariat"
	icon = 'icons/area/donk_area.dmi'
	icon_state = "secretary_quarters"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

// ------------------- CYBERSUN ENGINEERING CONTRACTORS -------------------

/area/station/engineering/cybersun
	icon = 'icons/area/donk_area.dmi'
	name = "\improper Cybersun Engineering Bay"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/station/engineering/cybersun/rtg_engine
	icon_state = "rtg"
	name = "\improper Radioisotope Thermoelectric Generator Room"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/station/engineering/cybersun/synth_storage
	icon_state = "synth_store"
	name = "\improper Cybersun Synth Storage"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/station/engineering/cybersun/robotics_lab
	icon_state = "robo_lab"
	name = "\improper Cybersun Robotics Lab"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/station/command/heads_quarters/two_ce
	icon_state = "two_ce"
	name = "\improper Cybersun Engineers Bedroom"
	sound_environment = SOUND_ENVIRONMENT_ROOM

// ----------------- Donk CO FOOD SCIENCE DEPARTMENT ----------------------

/area/station/science/food_science
	name = "\improper Donk Co. Food Science Department"
	icon = 'icons/area/donk_area.dmi'
	icon_state = "food_sci"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/station/science/food_science/test_kitchen
	name = "\improper Donk Co. Test Kitchen"
	icon_state = "test_kitchen"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/station/science/food_science/snackisfactory
	name = "\improper Donk Co. Snackisfactory™"
	icon_state = "snackisfactory"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/station/science/food_science/pantry
	name = "\improper Food Science Pantry"
	icon_state = "food_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/science/food_science/flavor_lab
	name = "\improper Donk Co. Flavor Lab"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/station/science/food_science/chem_storage
	name = "\improper Lab Storage"
	icon_state = "chem_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/science/food_science/filling_tank
	name = "\improper Donk Pocket™ Filling Tank"
	icon_state = "filling_tank"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/station/science/food_science/filling_tank/chicken
	name = "\improper Donk Pocket Chicken™ Filling Tank"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

// --------------------------- MISC ---------------------------

/area/spaceport
	name = "\improper Starport"
	icon = 'icons/area/donk_area.dmi'
	icon_state = "spaceport"
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/area/plaza
	name = "\improper Atrium"
	sound_environment = SOUND_ENVIRONMENT_CONCERT_HALL

/area/spaceport_lounge
	name = "\improper Donkstar Advantage™ Spacelounge"
	icon = 'icons/area/donk_area.dmi'
	icon_state = "spacelounge"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/maintenance_closet
	name = "\improper Maintenance Closet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED


// --------------------------- SYNDCOM ---------------------------

/area/centcom/syndcom
	name = "Syndicate Reconnaissance Outpost"
	icon = 'icons/area/donk_area.dmi'
	icon_state = "syndcom"
	sound_environment = SOUND_ENVIRONMENT_SEWER_PIPE

/area/centcom/syndcom/landing_pad
	name = "Syndicate Outpost Landing Pad"
	icon_state = "syndcom_landing_pad"
	ambience_index = AMBIENCE_ICEMOON
	sound_environment = SOUND_ENVIRONMENT_PARKING_LOT
	outdoors = TRUE
	static_lighting = FALSE
	base_lighting_alpha = 128

/area/centcom/syndcom/hangar
	name = "Syndicate Hangar"
	icon_state = "syndcom_hangar"
	ambience_index = AMBIENCE_ENGI
	sound_environment = SOUND_ENVIRONMENT_HANGAR

/area/centcom/syndcom/hangar_break
	name = "Outpost Hangar Breakroom"
	icon_state = "hangar_breakroom"
	ambience_index = AMBIENCE_GENERIC
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/centcom/syndcom/wilds
	name = "Syndicate Outpost Wilderness"
	icon_state = "syndcom_wilds"
	ambience_index = AMBIENCE_ICEMOON
	sound_environment = SOUND_AREA_LAVALAND
	outdoors = TRUE
	static_lighting = FALSE
	base_lighting_alpha = 128
