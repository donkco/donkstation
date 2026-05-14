#ifdef TESTING
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
 * Simulates the 5-round slate job assignment on a list of synthetic player slate configurations.
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
	var/list/log = list()
	var/N = length(player_slates)
	log += "=== simulate_job_assignment: [N] player(s) ==="

	// Build a lightweight state: list of assoc("slate"=..., "assigned_job"=null, "assigned_char"=0)
	var/list/players = list()
	for(var/i in 1 to N)
		players += list(list(
			"slate"         = player_slates[i],
			"assigned_job"  = null,
			"assigned_char" = 0,
			"player_id"     = "Player[i]",
		))

	// Simulate job position counts using a copy of joinable_occupations caps
	var/list/job_positions = list() // job title -> current count
	var/list/job_caps = list()      // job title -> spawn_positions cap (-1 = infinite)
	for(var/datum/job/job in joinable_occupations)
		job_positions[job.title] = 0
		job_caps[job.title] = job.spawn_positions

	for(var/round_index in 1 to 5)
		log += "--- Round [round_index] ---"
		// Collect candidates per job
		var/list/job_candidates = list() // job title -> list of assoc(player, char_slot)
		for(var/list/player in players)
			if(!isnull(player["assigned_job"]))
				continue
			var/list/slate = player["slate"]
			if(round_index > length(slate))
				continue
			var/list/entry = slate[round_index]
			if(!entry)
				continue
			var/job_title = entry["job"]
			var/char_slot = entry["char_slot"]
			if(!job_title || !char_slot)
				continue
			// Check if job exists and has space
			if(!(job_title in job_caps))
				log += "  [player["player_id"]]: job '[job_title]' not found, skipping"
				continue
			var/cap = job_caps[job_title]
			if(cap != -1 && job_positions[job_title] >= cap)
				log += "  [player["player_id"]]: job '[job_title]' is full ([job_positions[job_title]]/[cap])"
				continue
			if(isnull(job_candidates[job_title]))
				job_candidates[job_title] = list()
			job_candidates[job_title] += list(list("player" = player, "char_slot" = char_slot))

		// Resolve each job's candidates
		for(var/job_title as anything in job_candidates)
			var/list/candidates = job_candidates[job_title]
			var/list/winner_entry
			if(length(candidates) == 1)
				winner_entry = candidates[1]
				log += "  [job_title]: sole candidate [winner_entry["player"]["player_id"]] -> assigned"
			else
				var/list/contestant_names = list()
				for(var/list/c in candidates)
					contestant_names += c["player"]["player_id"]
				winner_entry = pick(candidates)
				log += "  [job_title]: contested by [contestant_names.Join(", ")] -> [winner_entry["player"]["player_id"]] wins"
			winner_entry["player"]["assigned_job"]  = job_title
			winner_entry["player"]["assigned_char"] = winner_entry["char_slot"]
			job_positions[job_title]++

	log += "--- Final assignments ---"
	var/unassigned_count = 0
	for(var/list/player in players)
		if(!isnull(player["assigned_job"]))
			log += "  [player["player_id"]]: [player["assigned_job"]] (slot [player["assigned_char"]])"
		else
			log += "  [player["player_id"]]: UNASSIGNED (would fall back to overflow role)"
			unassigned_count++
	log += "=== Done. [N - unassigned_count]/[N] assigned ==="
	return log
#endif
