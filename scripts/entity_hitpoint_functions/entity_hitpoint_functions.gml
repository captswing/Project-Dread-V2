/// @description Updates the entity's current hitpoint value with a modifier than can be either positive or
/// negative. Clamps the value between 0 and the current maximum hitpoints. On top of this, this is the
/// function that allows the entity's damage resistance value to be factored into the equation.
/// @param modifier
function entity_update_hitpoints(_modifier){
	hitpoints = clamp(hitpoints - (_modifier * damageResistance), 0, maxHitpoints);
	if (hitpoints <= 0 && !isInvincible){
		isDestroyed = true; // Destroys the entity on the next frame
	}
}

/// @description Sets the hitpoint value to an actual value instead of adding to the current hitpoints with
/// a standard modifier -- the entity's damage resistance isn't factored into this function. Other than that, 
/// it works the same as the above function.
/// @param newValue
function entity_set_hitpoints(_newValue){
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
function entity_set_max_hitpoints(_newValue, _restoreHealth){
	maxHitpoints = max(1, _newValue); // Prevent the maximum health from going below 1
	if (_restoreHealth || hitpoints > maxHitpoints){
		hitpoints = maxHitpoints;
	}
}

/// @description Adds/subtracts a determines health regeneration ratio from the current hp regen amount and 
/// speed of that regeneration. This allows for stacking of regeneration effects.
/// @param hitpoints
/// @param interval
function entity_update_regeneration_ratio(_hitpoints, _interval){
	if (regenSpeed != 0){ // Calculates an updated ratio for the health regen based on the addition of both ratios.
		var _factor = _interval / regenSpeed;
		hpRegenAmount = max(0, (hpRegenAmount * _factor) + _hitpoints);
		regenSpeed = (hpRegenAmount == 0) ? 0 : (regenSpeed * _factor);
	} else{ // Set the initial hitpoint regeneration if no regeneration ratio is currently present
		hpRegenAmount = max(0, _hitpoints); // Ensures no negative values are possible
		regenSpeed = _interval;
	}
}

/// @descrtipion Resets the entity's health regeneration ratio; stopping any current regeneration effect.
function entity_reset_regeneration(){
	regenSpeed = 0;
	hpRegenAmount = 0;
	hpRegenFraction = 0;
}