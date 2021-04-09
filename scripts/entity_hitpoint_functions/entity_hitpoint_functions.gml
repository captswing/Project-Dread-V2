/// @description Updates the entity's current hitpoint value with a modifier than can be either positive or
/// negative. Clamps the value between 0 and the current maximum hitpoints. On top of this, this is the
/// function that allows the entity's damage resistance value to be factored into the equation.
/// @param modifier
function update_hitpoints(_modifier){
	hitpoints = clamp(hitpoints - (_modifier * damageResistance), 0, maxHitpoints);
	if (hitpoints <= 0 && !isInvincible){
		isDestroyed = true; // Destroys the entity on the next frame
	}
}

/// @description Sets the hitpoint value to an actual value instead of adding to the current hitpoints with
/// a standard modifier -- the entity's damage resistance isn't factored into this function. Other than that, 
/// it works the same as the above function.
/// @param newValue
function set_hitpoints(_newValue){
	hitpoints = clamp(_newValue, 0, maxHitpoints);
	if (hitpoints <= 0 && !isInvincible){
		isDestroyed = true; // Destroys the entity on the next frame
	}
}

/// @description Adjusts the entity's maximum health to a new value that can be any number above 0. Optionally,
/// the entity's hitpoints can be fully restored to the new set maximum. If the new maximum is below the current
/// hitpoints of the entity, the hitpoints will be pulled down to the new maximum.
/// @param newValue
/// @param restoreHealth
function set_max_hitpoints(_newValue, _restoreHealth){
	maxHitpoints = max(1, _newValue); // Prevent the maximum health from going below 1
	if (_restoreHealth || hitpoints > maxHitpoints){
		hitpoints = maxHitpoints;
	}
}