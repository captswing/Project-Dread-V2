/// @description Checking for Nearby Light Sources

// Only check for light sources if the flag has been toggled
if (!checkForLights){
	return;
}

// Reset the canInteract flag before re-calculating interactability and disable the check for lights.
canInteract = false;
checkForLights = false;

// If the player's flashlight is on, there is no need to check if a light is nearby, as the
// player's flashlight will be nearby when they pick up the item anyway.
if (global.singletonID[? PLAYER] != noone && global.singletonID[? PLAYER].isLightActive){
	canInteract = true;
	return;
}

// Calculate if distance between position and light source if smaller than the light's radius
var _x, _y, _closestLight, _closestDist, _distance;
_x = interactCenter[X];
_y = interactCenter[Y];
_closestLight = noone;
with(obj_light){
	if (!trueLight){ // Ignore lights that aren't part of the environment
		continue;
	}
	// If no closest light exists; instantly set it to the first one that runs this code
	if (_closestLight == noone){
		_closestLight = id;
		_closestDist = point_distance(_x, _y, x, y);
		continue;
	}
	// Check distance between current light and the _closestLight's distance
	_distance = point_distance(_x, _y, x, y);
	if (_distance < _closestDist){
		_closestLight = id;
		_closestDist = _distance;
	}
}

// If no instance was found, that means there are currently no true light sources active in the current room.
// This means that the interactable cannot be interacted with if the code has gotten this far, since there
// is already an early out for when the player's flashlight is active.
if (_closestLight == noone){
	return;
}

// Calculate the radius of the light relative to the angle calculated between the light source and the interactable's positions.
// The resulting value will be used to determine if the interactable is close enough to the light to be interacted with without
// the need to use a flashlight.
var _radius, _angleFromLight, _radiusAtAngle;
_radius = [_closestLight.size[X], _closestLight.size[Y]];
_angleFromLight = degtorad(point_direction(_x, _y, _closestLight.x, _closestLight.y));
_radiusAtAngle = (_radius[X] * _radius[Y]) / sqrt(power(_radius[X] * sin(_angleFromLight), 2) + power(_radius[Y] * cos(_angleFromLight), 2));
// If the interactable is within the light's radius, let it be interacted with
if (_closestDist <= _radiusAtAngle){
	canInteract = true;
}