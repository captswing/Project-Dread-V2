/// @description The "Lightweight" weather effect object that creates a fog effect with multiple layers that
/// move in varying directions. The intensity of said weather is determined by the combined alpha level of
/// each layer, which is randomized from a range supplied to the object itself.
/// @param totalLayers
/// @param maxSpeed
/// @param minScale
/// @param maxScale
/// @param minAlpha
/// @param maxAlpha
function obj_weather_fog(_totalLayers, _maxSpeed, _minScale, _maxScale, _minAlpha, _maxAlpha) : par_weather() constructor{
	// Variables that store the width and height of the fog sprite in pixels.
	fogWidth = sprite_get_width(spr_mist_effect);
	fogHeight = sprite_get_height(spr_mist_effect);
	
	// The transition effect for this weather effect. It will simply fade the weather in and out at the
	// speed set by the variable "alphaSpeed."
	alpha = 0;
	alphaSpeed = 0.01;
	
	// Initialize the required number of layers; store that number in another variable.
	fogLayer = ds_list_create();
	var _scale, _xSize, _ySize, _data;
	for (var i = 0; i < _totalLayers; i++){
		// Calculate the scaling outside of the data array, which determines the size of the fog layer in
		// whole pixels. Then, the scale used to achieve that whole-pixel size is calculated in the struct.
		_scale = abs(random_range(_minScale, _maxScale));
		_xSize = round(fogWidth * _scale);
		_ySize = round(fogHeight * _scale);
		// Gather the data from the arguments and store them in a struct for the fog's layer attributes
		_data = {
			// The position of the fog in world-space
			xPos : 0,
			yPos : 0,
			// The fractional variables that prevent any sub-pixel movement
			xPosFraction : 0,
			yPosFraction : 0,
			// The horizontal and vertical velocities
			xSpeed : random_range(-_maxSpeed, _maxSpeed),
			ySpeed : random_range(-_maxSpeed, _maxSpeed),
			// The horizontal and vertical size of the fog layer's sprite, and its scaling factor
			xSize : _xSize,
			ySize : _ySize,
			xScale : _xSize / fogWidth,
			yScale : _ySize / fogHeight,
			// Finally, the alpha level of the layer
			alpha : abs(random_range(_minAlpha, _maxAlpha))
		}
		// After creating the data for the layer, add it to the list of layer data
		ds_list_add(fogLayer, _data);
	}
	numLayers = _totalLayers;
	
	/// @description Updates the positions of each layer in the fog effect. Also, handle alpha transition
	/// for the weather effect to smoothly enter and exit.
	function weather_update(){
		// Fade in the weather effect or out depending on if the effect is closing or not.
		alpha += isClosing ? -alphaSpeed * global.deltaTime : alphaSpeed * global.deltaTime;
		if (alpha < 0 && isClosing) {isDestroyed = true;}
		else if (alpha > 1) {alpha = 1;}
		
		// Loop through all active fog layers and update their relative positional offsets relative to their
		// size and scale to provide seemless movement and wrapping.
		for (var i = 0; i < numLayers; i++){
			with(fogLayer[| i]){
				// Handling horizontal movement; wrapping the value between its width and 0
				xPos += (xSpeed * global.deltaTime) + xPosFraction;
				xPosFraction = xPos - (floor(abs(xPos)) * sign(xPos));
				xPos -= xPosFraction;
			
				if (xPos < 0) {xPos += xSize;}
				else if (xPos > xSize) {xPos -= xSize;}
			
				// Handling vertical movement; wrapping the value between its height and 0
				yPos += (ySpeed * global.deltaTime) + yPosFraction;
				yPosFraction = yPos - (floor(abs(yPos)) * sign(yPos));
				yPos -= yPosFraction;
			
				if (yPos < 0) {yPos += ySize;}
				else if (yPos > ySize) {yPos -= ySize;}
			}
		}
	}
	
	/// @description Draws each of the layers onto the screen in order from first to last
	function weather_draw(){
		var _alpha = alpha; // Store the overall alpha into a temporary variable for fast access
		for (var i = 0; i < numLayers; i++){
			with(fogLayer[| i]){ // Tile the fog sprite to cover the entirety of the visible screen for each layer
				draw_sprite_tiled_ext(spr_mist_effect, 0, xPos, yPos, xScale, yScale, c_white, alpha * _alpha);
			}
		}
	}
	
	/// @description Cleans up the data structure containing the data for each of the fog layers
	function weather_destroy(){
		var _data = noone;
		for(var i = 0; i < numLayers; i++){
			_data = fogLayer[| i];
			delete _data;
		}
		ds_list_clear(fogLayer);
		ds_list_destroy(fogLayer);
	}
}