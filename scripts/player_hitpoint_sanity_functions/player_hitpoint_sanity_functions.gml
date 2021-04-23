/// @description Restores the player's current hitpoints relative to a percentage value provided in the argument
/// field. The function can only increase the player's health and will prevent it from going over the maximum.
/// @param percentHeal
function player_restore_hitpoints(_percentHeal){
	hitpoints += round(abs(_percentHeal) * maxHitpoints);
	if (hitpoints > maxHitpoints) {hitpoints = maxHitpoints;}
	return argument_count;
}

/// @description Increases the player's current maximum for their hitpoints by a modifier value. Much like the
/// hitpoint restoring function above, this function can only ever increase the player's current maximum. Also,
/// it can optionally restore the player's health to the new maximum value.
/// @param modifier
/// @param restoreHealth
function player_update_max_hitpoints(_modifier, _restoreHealth){
	maxHitpoints = max(1, maxHitpoints + _modifier);
	if (_restoreHealth || hitpoints > maxHitpoints) {hitpoints = maxHitpoints;}
	return argument_count;
}

/// @description Restores the player's current sanity relative to a percentage value provided in the argument
/// field. Basically, it works identically to how the player_restore_hitpoints function works -- just with
/// sanity instead of hitpoints.
/// @param percentHeal
function player_restore_sanity(_percentHeal){
	curSanity += round(abs(_percentHeal) * maxSanity);
	if (curSanity > maxSanity) {curSanity = maxSanity;}
	return argument_count;
}

/// @description Increases the player's current maximum sanity value by adding the provided modifier value.
/// Basically, it works identically to how player_update_max_hitpoints works -- just with sanity instead of
/// hitpoints, and minus the reset of any health regeneration stuff, since sanity doesn't have regeneration.
/// @param modifier
/// @param restoreSanity
function player_update_max_sanity(_modifier, _restoreSanity){
	maxSanity = max(1, maxSanity + _modifier);
	if (_restoreSanity || curSanity > maxSanity) {curSanity = maxSanity;}
	return argument_count;
}