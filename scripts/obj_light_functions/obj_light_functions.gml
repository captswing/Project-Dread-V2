/// @description Initializes a new circle light.
/// @param radiusX
/// @param radiusY
/// @param strength
/// @param color
/// @param trueLight
function light_create_circle(_radiusX, _radiusY, _strength, _color, _trueLight){
	// Set all of the light's characteristic variables for how it'll look in-game
	size = [_radiusX, _radiusY];
	strength = _strength;
	color = _color;
	// Finally, set whether or not the light is a true light source
	trueLight = _trueLight;
}

/// @description Initializes a new circle light with a temporary lifespan. After that time is up the light
/// will automatically destroy itself.
/// @param radiusX
/// @param radiusY
/// @param strength
/// @param color
/// @param lifespan
/// @param trueLight
function light_create_circle_temporary(_radiusX, _radiusY, _strength, _color, _lifespan, _trueLight){
	// Set all of the light's characteristic variables for how it'll look in-game
	size = [_radiusX, _radiusY];
	strength = _strength;
	color = _color;
	// Next, set the time in frames that the light's lifespan will be
	lifespan = _lifespan;
	// Finally, set whether or not the light is a true light source
	trueLight = _trueLight;
}

/// @description Initializes a new circle light that will flicker at varying levels of intensity for a varying
/// amount of time in between each change in light strength. After that it'll pick a from a range of time until
/// the next flicker and a range of intensity.
/// @param radiusX
/// @param radiusY
/// @param color
/// @param minIntensity
/// @param maxIntensity
/// @param minFlickerTime
/// @param maxFlickerTime
/// @param trueLight
function light_create_circle_flicker(_radiusX, _radiusY, _color, _minIntensity, _maxIntensity, _minFlickerTime, _maxFlickerTime, _trueLight){
	// Set all of the light's characteristic variables for how it'll look in-game
	size = [_radiusX, _radiusY];
	strength = random_range(_minIntensity, _maxIntensity);
	color = _color;
	// Next, store the provided intensity and flicker ranges
	flickerIntensityMin = _minIntensity;
	flickerIntensityMax = _maxIntensity;
	flickerMinRate = _minFlickerTime;
	flickerMaxRate = _maxFlickerTime;
	// Finally, set whether or not the light is a true light source
	trueLight = _trueLight;
}

/// @description Updates the position of an object's ambient light source. This should be called in the end step
/// event for whatever object is calling this script.
/// @param lightID
/// @param xPos
/// @param yPos
function light_update_position(_lightID, _xPos, _yPos){
	with(_lightID){
		x = _xPos;
		y = _yPos;
	}
}

/// @description Updates the radius, strength, and color of the provided light object. This one can only work
/// with CIRCULAR lights and will obviously screw up how a rectangle light is drawn.
/// @param lightID
/// @param xSize
/// @param ySize
/// @param strength
/// @param color
function light_update_settings(_lightID, _xSize, _ySize, _strength, _color){
	with(_lightID){
		size = [_xSize, _ySize];
		strength = _strength;
		color = _color;
	}
}