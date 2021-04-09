/// @description Changes the current weather, which instantly replaces the current effect with the new one.
/// This change should occur somewhere like between rooms in order to hide the fact that there's no closing
/// or opening transition between the effects.
/// @param weatherType
function set_weather(_weatherType){
	with(global.singletonID[? CONTROLLER]){
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
			case Weather.Mist:	
				weather = new obj_weather_fog(3, 0.8, 0.5, 2.5, 0.5, 0.9); 
				return;
			case Weather.Rain:
				/* TODO -- Create rain object here */ 
				return;
		}
	}
}

/// @description 
/// @param fadeColor
/// @param fadeSpeed
/// @param opaqueTime
function create_screen_fade(_fadeColor, _fadeSpeed, _opaqueTime){
	with(global.singletonID[? CONTROLLER]){
		if (fade == noone){
			fade = new obj_fade_screen(_fadeColor, _fadeSpeed, _opaqueTime);
			set_game_state(GameState.Paused, false);
		}
	}
}