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

/// @description Changes the current weather, which will instantly begin the weather's effect and fade in
/// transition if no effect was currently active. Otherwise, the weather effect that is currently active will
/// begin its closing transition, and the weather will be switched after that.
/// @param type
/// @param intensity
function set_weather(_type, _intensity){
	// Don't bother letting the weather change itself if it's changing to the exact same effect that's
	// currently active.
	if (weatherType == _type) {return;}
	weatherType = _type;
	
	// If no weather effect is currently active begin the effect without waiting for any transition.
	// Otherwise, begin the currently active effect's closing transition.
	if (weather == noone) {change_weather_effect(_type, _intensity);}
	else {weather.isClosing = true;}
}

/// @description The function that actually changes the weather effect to another or removes the effect in
/// its entirety. This function is only called after the transitional period for the active effect has
/// finished OR the weather effect is occurring after no weather previous effect.
/// @param type
/// @param intensity
function change_weather_effect(_type, _intensity){
	// Remove the previous weather effect from memory if one exists.
	if (weather != noone){
		delete weather;
		weather = noone;
	}
	
	// Find the desired weather type and create the accompanying object if it exists.
	switch(_type){
		case Weather.Mist: weather = new obj_weather_fog(3, 0.8, 1.0, 2.5, 0.55, 0.95); return;
		case Weather.Rain: /* TODO -- Create rain object here */ return;
	}
}

/// @description Creates a screen fadeaway of a given color, and pauses the entire game during that process.
/// If a fade effect is already active, this function will do nothing. The opaque time is equal to the number
/// of "frames" in a given second, which is equal to 60 per second in any actual calculations.
/// @param color
/// @param speed
/// @param opaqueTime
function create_screen_fade(_color, _speed, _opaqueTime){
	if (fade == noone){
		fade = new obj_fade_screen(_color, _speed, _opaqueTime);
		set_game_state(GameState.Paused, false);
	}
}

/// @description Frees all surfaces from texture memory. This is useful for resizing surfaces whenever 
/// the game's aspect ratio is changed.
function clear_surfaces(){
	if (surface_exists(resultSurface)) {surface_free(resultSurface);}
	if (surface_exists(auxSurfaceA)) {surface_free(auxSurfaceA);}
	if (surface_exists(auxSurfaceB)) {surface_free(auxSurfaceB);}
}