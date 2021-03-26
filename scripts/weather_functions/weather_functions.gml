/// @description Updates the currently active weather effect and handles transitions between weather 
/// effects whenever necessary.
function update_weather_effect(){
	if (weatherID >= 0){ // A weather swap is currently active; fade previous weather out and swap over
		weatherAlpha -= weatherAlphaSpd * global.deltaTime;
		if (weatherAlpha <= 0){
			switch_weather_effect(weatherID);
			weatherAlpha = 0;
			weatherID = -1;
		}
	} else if (weatherEffect != noone){ // No weather swap is happening, fade in
		weatherAlpha += weatherAlphaSpd * global.deltaTime;
		if (weatherAlpha >= 1){
			weatherAlpha = 1;
		}
	}
	// Always update the weather effect, regardless of fading in or out
	with(weatherEffect) {Update(global.deltaTime);}
}


/// @description Changes the weather to a new effect, which starts the fading transition for it. The actual
/// change for the effect occurs right in the middle fo the transition, which is when the alpha for the 
/// weather effect is at exactly 0.
/// @param effectID
function set_weather_effect(_effectID){
	with(global.controllerID) {weatherID = _effectID;}
}

/// @description Actually swaps the weather object over to the next weather setting. This occurs right after
/// the alpha transition hits exactly zero, which then causes it to reset and fade in with the new effect.
/// @param effectID
function switch_weather_effect(_effectID){
	// Removes the previous weather effect from memory before creating the new one
	with(weatherEffect) {Destroy();}
	delete weatherEffect;
	
	// Finds the desired effect and initializes it
	switch(_effectID){
		case Weather.Mist: // Creates misty weather
			weatherEffect = new WeatherMist();
			with(weatherEffect){ // Creates 3 different layers for a complex look
				mist_add_layer(0, -0.35, 0.8);
				mist_add_layer(-0.5, 0.1, 0.95);
				mist_add_layer(-0.1, -0.2, 0.7);
			}
			break;
		case Weather.Rain: // Creates rainy weather
			weatherEffect = new WeatherRain();
			break;
		default: // Resets the variable back to noone
			weatherEffect = noone;
			break;
	}
}

/// @description The parent "lightweight" object that contains all of the functions that can be overwritten 
/// by each weather effect. These are all optional, and the child objects will function without overriding 
/// these skeleton functions, but if any other functions are created to replace these three, they won't work.
function WeatherEffect() constructor{
	function Update(_delta){}
	function Draw(_alpha){}
	function Destroy(){}
}

/// @description The data for the "lightweight" object that handles the mist weather effect. It allows for
/// multiple layers with unique velocity values, alpha levels, and positions to create a unique effect despite
/// only using a single 64 by 64 pixel texture.
function WeatherMist() : WeatherEffect() constructor{
	// Variables that assist and track information about the various layers that the mist effect can contain.
	// The list stores the positional and velocity data of their respective layers, and the height and width
	// variables store the size of the texture for drawing purposes. The number of layers is stored in the
	// last variable so calls to ds_list_size every frame don't need to happen.
	mistLayers = ds_list_create();
	mistWidth = sprite_get_width(spr_mist_effect);
	mistHeight = sprite_get_height(spr_mist_effect);
	numLayers = 0;
	
	// @description Loop through all the currently existing mist layers and update their positions.
	function Update(_delta){
		for (var i = 0; i < numLayers; i++){
			var _map = mistLayers[| i];
		
			// Horizontal movement
			_map[? "x"] += _map[? "hspd"] * _delta;
			// Wrapping the position once it exceeds the sprite's width or goes below the 
			// negative of that same value.
			if (_map[? "x"] > mistWidth) {_map[? "x"] = 0;} 
			else if (_map[? "x"] < 0) {_map[? "x"] = mistWidth;}
			
			// Vertical movement
			_map[? "y"] += _map[? "vspd"] * _delta;
			// Wrapping the position once it exceeds the sprite's height or goes below the 
			// negative of that same value.
			if (_map[? "y"] > mistHeight) {_map[? "y"] = 0;}
			else if (_map[? "y"] < 0) {_map[? "y"] = mistHeight;}
		}
	}
	
	// @description Loop through all the currently existing mist layer and draw them to the screen relative 
	// to their current positional offsets.
	function Draw(_alpha){
		// Store the offset x and y positions to begin drawing the mist texture at.
		var _xOffset, _yOffset, _map;
		_xOffset = floor(get_camera_x() / mistWidth) * mistWidth;
		_yOffset = floor(get_camera_y() / mistHeight) * mistHeight;
		// Loop through and repeat the mist texture vertically and horizontally until it covers 
		// the entire screen with the texture.
		for (var i = 0; i < numLayers; i++){
			_map = mistLayers[| i];
			for (var xx = -mistWidth; xx <= WINDOW_WIDTH; xx += mistWidth){
				for (var yy = -mistHeight; yy <= WINDOW_HEIGHT + mistHeight; yy += mistHeight){
					draw_sprite_ext(spr_mist_effect, 0, _xOffset + xx + _map[? "x"], _yOffset + yy + _map[? "y"], 1, 1, 0, c_white, _map[? "alpha"] * _alpha);
				}
			}
		}
	}
	
	// @description Cleans up the mist layer data before removing this "lightweight" object from memory.
	function Destroy(){
		while(numLayers > 0) {mist_remove_layer(0);}
		ds_list_destroy(mistLayers);
	}
	
	/// @description Adds a new layer to the mist effect with a user-defined hspd, vspd, and alpha level. The 
	/// first two handle the horizontal and vertical velocity of the layer respectively, and the final variable
	/// handles the strength of the layer -- determining its visiblility on the screen.
	/// @param hspd
	/// @param vspd
	/// @param alpha
	function mist_add_layer(_hspd, _vspd, _alpha){
		// Populate the map data with information about the mist layer
		var _data = ds_map_create();
		ds_map_add(_data, "x",		0);
		ds_map_add(_data, "y",		0);
		ds_map_add(_data, "hspd",	_hspd);
		ds_map_add(_data, "vspd",	_vspd);
		ds_map_add(_data, "alpha",	_alpha);
		// Finally, add that map to the list of current layers
		ds_list_add(mistLayers, _data);
		numLayers++; // Increment the total number of active mist layers
	}
	
	/// @description Removes a layer of mist from the given index. If the layer provided isn't within the valid
	/// range of layers, nothing will occur.
	/// @param index
	function mist_remove_layer(_index){
		// Destroys the map containing the map data before deleting its pointer; preventing any memory leaks
		ds_map_destroy(mistLayers[| _index]);
		ds_list_delete(mistLayers, _index);
		numLayers--; // Decrement the total number of active mist layers
	}
}

/// @description
function WeatherRain() : WeatherEffect() constructor{
	
	function Update(_delta){
		
	}
	
	function Draw(_alpha){
		
	}
	
	function Destroy(){
		
	}
}

function RainDroplet(_x, _y) constructor{
	
	xPos = _x;
	yPos = _y;
	
	
}