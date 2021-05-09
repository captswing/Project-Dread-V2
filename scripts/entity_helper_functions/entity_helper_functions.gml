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
function entity_set_sprite(_sprIndex, _sprDirections){
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
/// damage. Also, the second variable will optionally lock the entity for a set number of frames.
/// @param damage
/// @param stunTime
function entity_set_hit(_damage, _stunTime){
	entity_update_hitpoints(_damage);
	stunLockTimer = _stunTime;
	isHit = true;
	if (_stunTime > 0){ // Changes the entity into the universal stun lock state
		set_cur_state(state_entity_stun_locked);
		animateSprite = false;
	}
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
/// @param persistent
function entity_create_light(_offsetX, _offsetY, _radiusX, _radiusY, _strength, _color, _trueLight, _persistent) {
	ambLight = instance_create_depth(x + _offsetX, y + _offsetY, ENTITY_DEPTH, obj_light);
	with(ambLight){ // Apply all the entity's settings to the light itself
		light_create_circle(_radiusX, _radiusY, _strength, _color, _trueLight);
		persistent = _persistent;
	}
	lightPosition = [_offsetX, _offsetY];
}

/// @description Creates an audio emitter that will be attached to an entity at a provided offset. The 
/// offset values are stored in a 2-index array, and the other arguments are passed into the audio emitter
/// object themselves.
/// @param offsetX
/// @param offsetY
/// @param sound
/// @param falloffRefDist
/// @param falloffMaxDist
/// @param falloffFactor
/// @param persistent
function entity_create_emitter(_offsetX, _offsetY, _sound, _falloffRefDist, _falloffMaxDist, _falloffFactor, _persistent){
	audioEmitter = instance_create_depth(x + _offsetX, y + _offsetY, ENTITY_DEPTH, obj_emitter);
	with(audioEmitter){ // Apply all the settings to the emitter object
		emitter_create(_sound, _falloffRefDist, _falloffMaxDist, _falloffFactor);
		persistent = _persistent;
	}
	emitterPosition = [_offsetX, _offsetY];
}