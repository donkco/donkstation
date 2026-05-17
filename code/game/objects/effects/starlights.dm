/obj/effect/starlight_window
	name = "starlight"
	icon = 'icons/effects/starlights.dmi'
	icon_state = "starlight-1"
	layer = LIGHTING_PRIMARY_LAYER
	plane = O_LIGHTING_VISUAL_PLANE
	blend_mode = BLEND_ADD
	color = COLOR_BLUE_GRAY
	blocks_emissive = EMISSIVE_BLOCK_NONE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/starlight_window/circle
	icon_state = "starlight-2"
	color = "#d3c783"

/obj/effect/starlight_window/circle_bars
	icon_state = "starlight-3"
	color = "#d3c783"

/obj/effect/starlight_window/square_bars
	icon_state = "starlight-4"
	color = "#9dd1d1"

/obj/effect/starlight_window/thin_slits
	name = "suspicious light"
	icon_state = "starlight-5"
	color = "#d42651"

/obj/effect/starlight_window/sweeper
	icon = 'icons/effects/donk_effects_96x96.dmi'
	icon_state = "starlight-sweeper"

	color = "#aed2db"
	SET_BASE_PIXEL(-32,-32)
