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
	
	// Initialize the required number of layers; store that number in another variable.
	fogLayer = ds_list_create();
	var _scale, _data;
	for (var i = 0; i < _totalLayers; i++){
		// Calculate the scaling outside of the data array
		_scale = abs(random_range(_minScale, _maxScale));
		// Gather the data from the arguments and store them in a struct for the fog's layer attributes
		_data = {
			// The position of the fog in world-space
			xPos : random(fogWidth * _scale),
			yPos : random(fogHeight * _scale),
			// The fractional variables that prevent any sub-pixel movement
			xPosFraction : 0,
			yPosFraction : 0,
			// The horizontal and vertical velocities
			xSpeed : random_range(-_maxSpeed, _maxSpeed),
			ySpeed : random_range(-_maxSpeed, _maxSpeed),
			// The horizontal and vertical size of the fog layer's sprite, and its scaling factor
			xSize : fogWidth * _scale,
			ySize : fogHeight * _scale,
			scale : _scale,
			// Finally, the alpha level of the layer
			alpha : abs(random_range(_minAlpha, _maxAlpha))
		}
		// After creating the data for the layer, add it to the list of layer data
		ds_list_add(fogLayer, _data);
	}
	numLayers = _totalLayers;
	
	// The alpha level for entirety of the weather effect, which causes a smooth fade in when 
	// the fog effect starts up in-game.
	alpha = 0;
	
	// Handles the animation of the fog; fading it in and out smoothly depending on if the 
	// weather is beginning or ending. The speed determines how fast the fading is.
	lerpProgress = 0;
	lerpSpeed = 50;
	
	/// @description Updates the positions of each layer in the fog effect
	function weather_update(){
		// Fading in/fading out the fog depending on if the weather is starting or ending
		lerpProgress += ((1 - lerpProgress) / lerpSpeed) * global.deltaTime;
		alpha = !isClosing ? lerp(0, 1, lerpProgress) : lerp(0, 1, 1 - lerpProgress);
		// Letting the handler object know this object needs to be deleted from memory
		if (isClosing && alpha < 0.05){
			isDestroyed = true;
			return; // Don't bother updating the layer positions
		}
		
		// Looping through each layer and updating its position based on their movement speeds
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
		// Don't bother drawing if the image isn't visible
		if (alpha <= 0) {return;}
		// Loop through and draw all active layers with integer position values, to stop any sub-pixel drawing
		var _alpha = alpha;
		for (var i = 0; i < numLayers; i++){
			with(fogLayer[| i]){
				// Ignore any fog layers that have a scale of 0 or an alpha of 0
				if (alpha == 0 || xSize == 0 || ySize == 0) {continue;}
				// Tile the fog sprite to cover the entirety of the visible screen for each layer
				draw_sprite_tiled_ext(spr_mist_effect, 0, xPos, yPos, scale, scale, c_white, _alpha * alpha);
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