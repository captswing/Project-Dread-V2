/// @description
/// @param percentHeal
function player_restore_hitpoints(_percentHeal){
	hitpoints += round(abs(_percentHeal) * maxHitpoints);
	if (hitpoints > maxHitpoints) {hitpoints = maxHitpoints;}
	return argument_count;
}

/// @description
/// @param modifier
/// @param restoreHealth
function player_update_max_hitpoints(_modifier, _restoreHealth){
	maxHitpoints = max(1, maxHitpoints + _modifier);
	if (_restoreHealth || hitpoints > maxHitpoints) {hitpoints = maxHitpoints;}
	return argument_count;
}

/// @description
/// @param percentHeal
function player_restore_sanity(_percentHeal){
	curSanity += round(abs(_percentHeal) * maxSanity);
	if (curSanity > maxSanity) {curSanity = maxSanity;}
	return argument_count;
}

/// @description
/// @param modifier
/// @param restoreSanity
function player_update_max_sanity(_modifier, _restoreSanity){
	maxSanity = max(1, maxSanity + _modifier);
	if (_restoreSanity || curSanity > maxSanity) {curSanity = maxSanity;}
	return argument_count;
}