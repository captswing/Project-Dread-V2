/// @description Sets the currently executed state to a new function index. Also stores the last state within 
/// its own variable for easy referece and comparison. If the passed in function is identical to the current 
/// state, don't change the state.
/// @param newState
function set_cur_state(_newState){
	if (_newState != curState){
		lastState = curState;
		curState = _newState;
	}
}

/// @description Updates the entity's current sprite, as well as the two variables that store data for the
/// sprite that are useful for accurate animating. The number of directions used can be whatever the sprite
/// requires, but it should be either 4 or 8 directions.
/// @param sprIndex
/// @param sprDirections
function set_sprite(_sprIndex, _sprDirections){
	if (sprite_index == _sprIndex){
		return false; // Don't bother updating the sprite data if the sprite hasn't actually changed
	}
	// Reset the local frame value, and update the current sprite
	sprite_index = _sprIndex;
	sprDirections = round(360 / _sprDirections);
	sprFrames = sprite_get_number(sprite_index) / _sprDirections;
	sprSpeed = sprite_get_speed(sprite_index) / ANIMATION_FPS;
	localFrame = 0;
	return true; // The wprite was changed, return true
}

/// @description Deals out a variable amount of damage and sets the flag for temporary invulnerability from
/// damage. Also, the second variable will optionally lock the entity for a set number of frames during said
/// invulnerability.
/// @param damage
/// @param stunTime
function set_entity_hit(_damage, _stunTime){
	update_hitpoints(_damage);
	stunLockTimer = clamp(_stunTime, 0, timeToRecover);
	isHit = true;
}

/// @description Creates a light for the entity's ambLight variable. From there, the size, color, 
/// strength, and offset position are all applied to said light.
/// @param offsetX
/// @param offsetY
/// @param radiusX
/// @param radiusY
/// @param strength
/// @param color
/// @param trueLight
function entity_create_light(_offsetX, _offsetY, _radiusX, _radiusY, _strength, _color, _trueLight) {
	ambLight = instance_create_depth(x + _offsetX, y + _offsetY, ENTITY_DEPTH, obj_light);
	with(ambLight){ // Apply all the entity's settings to the light itself
		light_create_circle(_radiusX, _radiusY, _strength, _color, _trueLight);
	}
	lightPosition = [_offsetX, _offsetY];
}