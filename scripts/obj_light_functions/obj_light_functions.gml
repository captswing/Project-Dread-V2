/// @description Initializes a new circle light.
/// @param radiusX
/// @param radiusY
/// @param strength
/// @param color
/// @param trueLight
function light_create_circle(_radiusX, _radiusY, _strength, _color, _trueLight){
	// Set all of the light's member variables
	size = [_radiusX, _radiusY];
	strength = _strength;
	color = _color;
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