/**
 * Generates random test slates and runs simulate_job_assignment() on them.
 * Useful for quick smoke-testing the lottery without manually constructing slates.
 *
 * player_count: How many simulated players to generate. Default 8.
 * max_picks:    How many slate slots each player actually fills in (rest are blank). Default 3.
 *
 * Each player gets a randomly-ordered selection of up to max_picks distinct jobs, all on char_slot 1.
 * Some jobs will be contested; some will be uncontested. Results are returned as a list of log strings.
 */
/datum/controller/subsystem/job/proc/simulate_job_assignment_random(player_count = 8, max_picks = 3)
	// Build a pool of job titles with at least one spawn position available.
	var/list/job_pool = list()
	for(var/datum/job/job in joinable_occupations)
		if(job.spawn_positions != 0)
			job_pool += job.title

	if(!length(job_pool))
		return list("ERROR: no joinable occupations available for random sim")

	var/list/player_slates = list()
	for(var/p in 1 to player_count)
		var/list/slate = list()
		var/list/used_jobs = list()
		for(var/slot_index in 1 to 5)
			if(slot_index <= max_picks)
				// Pick a random job not already used in this player's slate, cycling the pool if exhausted.
				var/list/choices = job_pool.Copy()
				choices -= used_jobs
				if(!length(choices))
					choices = job_pool.Copy()
				var/picked = pick(choices)
				used_jobs += picked
				slate += list(list("char_slot" = 1, "job" = picked))
			else
				slate += list(list("char_slot" = 0, "job" = ""))
		player_slates += list(slate)

	return simulate_job_assignment(player_slates)

/**
 * Simulates the 5-round slate job assignment on a list of synthetic player slate configurations
 * by routing through the real slate_divide_occupations() proc with mock players.
 * This means any bug in the real assignment logic will also reproduce here.
 *
 * player_slates: A list of assoc lists, each representing one player's job_slate.
 *   Format: list(list("char_slot"=1,"job"="Botanist"), list("char_slot"=2,"job"="Chef"), ...)
 *
 * Returns a list of log strings describing the assignment results.
 *
 * Example usage in a test:
 *   var/list/player1_slate = list(
 *       list("char_slot"=1, "job"="Botanist"),
 *       list("char_slot"=1, "job"="Chef"),
 *       list("char_slot"=0, "job"=""),
 *       list("char_slot"=0, "job"=""),
 *       list("char_slot"=0, "job"=""),
 *   )
 *   var/list/results = SSjob.simulate_job_assignment(list(player1_slate, ...))
 *   for(var/line in results) log_test(line)
 */
/datum/controller/subsystem/job/proc/simulate_job_assignment(list/player_slates)
	var/N = length(player_slates)

	// ---- Snapshot real state so we can restore it after the sim ----
	var/list/saved_unassigned = unassigned.Copy()
	var/list/position_snapshot = list()
	var/list/spawn_snapshot = list()
	for(var/datum/job/job as anything in joinable_occupations)
		position_snapshot[job] = job.current_positions
		spawn_snapshot[job.title] = job.spawn_positions

	// ---- Build synthetic new_player mobs ----
	var/list/sim_mobs = list()
	for(var/i in 1 to N)
		var/mob/dead/new_player/sim_player = new /mob/dead/new_player()
		sim_player.name = "SimPlayer[i]"
		sim_player.mind_initialize()
		// Provide a mock client with a prefs datum so slate/eligibility checks work.
		var/datum/client_interface/mock_ci = new()
		mock_ci.prefs = new /datum/preferences(mock_ci)
		mock_ci.prefs.job_slate = player_slates[i].Copy()
		sim_player.mock_client = mock_ci
		sim_mobs += sim_player

	// ---- Pre-sim: build contention data with per-player weight + round info ----
	// job_contention: assoc (job title -> list of assoc("idx"=I, "weight"=W, "round"=R))
	// player_job_round: list indexed by player i, each entry an assoc (job title -> round index)
	var/list/job_contention = list()
	var/list/player_job_round = list()
	for(var/i in 1 to N)
		var/datum/client_interface/ci = sim_mobs[i].mock_client
		var/list/pjr = list()
		var/list/seen_jobs = list()
		for(var/round_i in 1 to length(player_slates[i]))
			var/list/entry = player_slates[i][round_i]
			if(!islist(entry) || entry["char_slot"] <= 0 || !length(entry["job"]))
				continue
			var/job_title = entry["job"]
			if(job_title in seen_jobs)
				continue
			seen_jobs += job_title
			pjr[job_title] = round_i
			var/datum/job/j = get_job(job_title)
			if(!j)
				continue
			var/weight = j.get_job_weight(ci)
			if(!(job_title in job_contention))
				job_contention[job_title] = list()
			job_contention[job_title] += list(list("idx" = i, "weight" = weight, "round" = round_i))
		player_job_round += list(pjr)

	// ---- Run the real assignment using the sim mobs ----
	unassigned = sim_mobs.Copy()
	slate_divide_occupations(allow_all = TRUE)

	// ---- Collect per-player results ----
	// player_result_job[i]   = assigned job title, or null
	// player_result_round[i] = round the job came from (1-5), or 0
	var/list/player_result_job = list()
	var/list/player_result_round = list()
	for(var/i in 1 to N)
		var/mob/dead/new_player/sim_player = sim_mobs[i]
		var/datum/job/result_job = sim_player.mind?.assigned_role
		if(!isnull(result_job) && !istype(result_job, /datum/job/unassigned))
			player_result_job += result_job.title
			// Find which slate round this job came from
			var/found_round = 0
			var/list/pjr = player_job_round[i]
			if(result_job.title in pjr)
				found_round = pjr[result_job.title]
			player_result_round += found_round
		else
			player_result_job += null
			player_result_round += 0

	// ---- Pre-compute cumulative assignments per job per round for "job full" detection ----
	// assignments_before_round[job_title] = list indexed 1..5 where [r] = count assigned in rounds 1..(r-1)
	var/list/assignments_before_round = list()
	for(var/job_title in job_contention)
		var/list/fills_at = list(0, 0, 0, 0, 0)
		for(var/i in 1 to N)
			var/aj = player_result_job[i]
			var/ar = player_result_round[i]
			if(aj == job_title && ar >= 1 && ar <= 5)
				fills_at[ar]++
		var/list/before = list(0, 0, 0, 0, 0)
		var/cumulative = 0
		for(var/r in 1 to 5)
			before[r] = cumulative
			cumulative += fills_at[r]
		assignments_before_round[job_title] = before

	// ---- Build output ----
	var/list/log = list()
	log += "=== simulate_job_assignment: [N] player(s) ==="
	var/assigned_count = 0
	var/list/round_assignments = list(list(), list(), list(), list(), list())
	for(var/i in 1 to N)
		var/assigned_job = player_result_job[i]
		var/assigned_round = player_result_round[i]
		var/mob/dead/new_player/sim_player = sim_mobs[i]
		if(assigned_job)
			var/char_slot = sim_player.mind.assigned_character_slot
			log += "  SimPlayer[i]: [assigned_job] (char_slot [char_slot])"
			assigned_count++
			if(assigned_round >= 1 && assigned_round <= 5)
				round_assignments[assigned_round] += "SimPlayer[i]: [assigned_job]"
		else
			log += "  SimPlayer[i]: UNASSIGNED (would fall back to overflow role)"
		// Show full slate, highlighting the winning slot with << >>
		var/list/slate_parts = list()
		for(var/slot_i in 1 to 5)
			var/list/entry = player_slates[i][slot_i]
			var/slot_job = (islist(entry) && entry["char_slot"] > 0) ? entry["job"] : ""
			var/display = (slot_job != "") ? slot_job : "-"
			if(slot_job != "" && slot_job == assigned_job)
				display = "<<[slot_job]>>"
			slate_parts += "[slot_i]:[display]"
		log += "    [jointext(slate_parts, " | ")]"

	// ---- Per-round breakdown ----
	log += "--- Round Breakdown ---"
	for(var/round_i in 1 to 5)
		var/list/winners = round_assignments[round_i]
		if(length(winners))
			log += "  Round [round_i]: [length(winners)] assigned — [english_list(winners)]"
		else
			log += "  Round [round_i]: 0 assigned"

	// ---- Per-job stats with contender fate explanations ----
	log += "--- Job Stats ---"
	for(var/datum/job/job as anything in joinable_occupations)
		var/list/contenders = job_contention[job.title]
		if(!length(contenders))
			continue
		var/initial_slots = spawn_snapshot[job.title]
		var/filled = job.current_positions - position_snapshot[job]
		var/initial_str = (initial_slots == -1) ? "∞" : "[initial_slots]"
		var/list/before_round = assignments_before_round[job.title]
		var/list/contender_strs = list()
		for(var/list/contender as anything in contenders)
			var/c_idx = contender["idx"]
			var/c_weight = contender["weight"]
			var/c_round = contender["round"]
			var/c_assigned_job = player_result_job[c_idx]
			var/c_assigned_round = player_result_round[c_idx]
			var/fate
			if(c_assigned_job == job.title)
				fate = "selected"
			else if(c_weight <= 0)
				fate = "zero weight, excluded from lottery"
			else if(c_assigned_round > 0 && c_assigned_round < c_round)
				fate = "already assigned [c_assigned_job] in round [c_assigned_round]"
			else
				// Player competed but didn't win — determine why
				var/filled_before = (c_round >= 1 && c_round <= 5) ? before_round[c_round] : 0
				if(initial_slots != -1 && filled_before >= initial_slots)
					fate = "job was full by round [c_round]"
				else if(c_assigned_round > c_round)
					fate = "lost lottery, later won [c_assigned_job] in round [c_assigned_round]"
				else
					fate = "lost lottery, remained unassigned"
			contender_strs += "SimPlayer[c_idx](w=[c_weight]) ([fate])"
		log += "  [job.title]: [filled]/[initial_str] slots filled | [length(contenders)] contender\s: [english_list(contender_strs)]"

	log += "=== Done. [assigned_count]/[N] assigned ==="

	// ---- Restore real state ----
	unassigned = saved_unassigned
	for(var/datum/job/job as anything in joinable_occupations)
		if(!isnull(position_snapshot[job]))
			job.current_positions = position_snapshot[job]

	// ---- Clean up synthetic mobs and mock clients ----
	for(var/mob/dead/new_player/sim_player in sim_mobs)
		if(sim_player.mock_client)
			qdel(sim_player.mock_client)
		qdel(sim_player)

	return log
