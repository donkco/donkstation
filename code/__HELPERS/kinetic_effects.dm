/// Launches the object in an arc a few px away. direction is determiner by min and max angle args, speed is time per 1px distance.
/atom/movable/proc/fling(min_dist = 2, max_dist = 12, min_angle = 0, max_angle = 359, speed = 20 MILLISECONDS)
	var/angle = rand(min_angle, max_angle)
	var/dist = rand(min_dist, max_dist)
	var/vector/launch_vector = vector(pixel_x + dist * cos(angle), pixel_y + dist * sin(angle))

	var/height = round(dist * 0.7)
	var/launch_duration = dist * speed

	animate(src, time = launch_duration / 2, pixel_z = pixel_z + height)
	animate(time = launch_duration / 2, pixel_z = 0, easing = BOUNCE_EASING|EASE_OUT)
	animate(time = launch_duration, pixel_x = launch_vector.x, pixel_y = round(launch_vector.y * 0.7), flags = ANIMATION_PARALLEL)
