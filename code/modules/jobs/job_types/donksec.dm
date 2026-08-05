/datum/job/donksec
	title = JOB_SECURITY_OFFICER
	description = "Protect company assets, follow the Standard Operating \
		Procedure, eat donuts."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
total_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	spawn_positions = 5 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "the Head of Security"
	minimal_player_age = 7
	exp_requirements = 300
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "SECURITY_OFFICER"

	outfit = /datum/outfit/job/donksec
	plasmaman_outfit = /datum/outfit/plasmaman/security

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SEC

	desensitized_base = DESENSITIZED_THRESHOLD
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_SECURITY_OFFICER
	bounty_types = CIV_JOB_SEC
	departments_list = list(
		/datum/job_department/security,
		)

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law, /obj/item/clothing/head/beret/sec)

	mail_goodies = list(
		/obj/item/food/donut/caramel = 10,
		/obj/item/food/donut/matcha = 10,
		/obj/item/food/donut/blumpkin = 5,
		/obj/item/clothing/mask/whistle = 5,
		/obj/item/melee/baton/security/boomerang/loaded = 1
	)
	rpg_title = "Guard"
	job_flags = STATION_JOB_FLAGS | JOB_ANTAG_PROTECTED

/datum/outfit/job/donksec
	name = "Security Officer"
	jobtype = /datum/job/donksec

	id_trim = /datum/id_trim/job/security_officer
	uniform = /obj/item/clothing/under/syndicate/donksec
	suit = null
	suit_store = /obj/item/melee/rubber_batong

	backpack_contents = list(
		/obj/item/evidencebag = 1,
		)
	belt = /obj/item/modular_computer/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	gloves = /obj/item/clothing/gloves/color/black/security
	head = /obj/item/clothing/head/donksec
	shoes = /obj/item/clothing/shoes/jackboots/sec
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld

	backpack = /obj/item/storage/backpack/donksec
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/donksec
	messenger = /obj/item/storage/backpack/messenger/donksec

	box = /obj/item/storage/box/survival

