/// @description Sets the color, brightness, contrast, and saturation of the lighting inside of whatever room
/// calls this function. MAKE SURE TO ONLY USE THIS IN THE CREATION CODE OF A GIVEN ROOM.
/// @param color[r/g/b]
/// @param brightness
/// @param contrast
/// @param saturation
function set_lighting(_color, _brightness, _contrast, _saturation) {
	lightColor = _color;
	lightBrightness = _brightness;
	lightContrast = _contrast;
	lightSaturation = _saturation;
}

/// @description Changes the current weather, which instantly replaces the current effect with the new one.
/// This change should occur somewhere like between rooms in order to hide the fact that there's no closing
/// or opening transition between the effects.
/// @param weatherType
function set_weather(_weatherType){
	// Don't bother wasting time changing weather object if the type is being changed to the same one as before
	if (weatherType == _weatherType) {return;}
	weatherType = _weatherType;
		
	// Remove the previous weather effect from memory if one exists.
	if (weather != noone){
		delete weather;
		weather = noone;
	}

	// Find the desired weather type and create the accompanying object if it exists.
	switch(weatherType){
		case Weather.Mist: weather = new obj_weather_fog(3, 0.8, 1.0, 2.5, 0.55, 0.95); return;
		case Weather.Rain: /* TODO -- Create rain object here */ return;
	}
}

/// @description 
/// @param fadeColor
/// @param fadeSpeed
/// @param opaqueTime
function create_screen_fade(_fadeColor, _fadeSpeed, _opaqueTime){
	if (fade == noone){
		fade = new obj_fade_screen(_fadeColor, _fadeSpeed, _opaqueTime);
		set_game_state(GameState.Paused, false);
	}
}

/// @description Frees all surfaces from texture memory. This is useful for resizing surfaces whenever the game's
/// aspect ratio is changed.
function clear_surfaces(){
	if (surface_exists(resultSurface)) {surface_free(resultSurface);}
	if (surface_exists(auxSurfaceA)) {surface_free(auxSurfaceA);}
	if (surface_exists(auxSurfaceB)) {surface_free(auxSurfaceB);}
}