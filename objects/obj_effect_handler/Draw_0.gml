/// @description Drawing Other World-Space Effects (Weather, Reflections, etc.)

// These world-space effects should be drawn in the order below:
//		1	--		Active Weather Effect
//		2	--		Reflection Effect

// Display the current weather effect if one is active
with(weather) {weather_draw();}