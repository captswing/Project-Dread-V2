/// @description Sets the entity's maximum movement speeds. HOWEVER, it sets the TRUE constant hspd and vspd
/// instead of the maximum values that are used. This allows for adjustments on a percent basis from the initial
/// hspd and vspd maximums; preventing weird errors from occurring when adding/removing movement buffs and debuffs.
/// @param hspd
/// @param vspd
/// @param updateCurrent
function entity_set_max_speed(_hspd, _vspd, _updateCurrent){
	maxHspdConst = _hspd;
	maxVspdConst = _vspd;
	if (_updateCurrent){
		maxHspd = maxHspdConst;
		maxVspd = maxVspdConst;
	}
}

/// @description Adjusts the editable hspd and vspd maximum by some modifier value. However, it will prevent
/// the maximum values for either hspd or vspd to go below 0.
/// @param hspdMod
/// @param vspdMod
function entity_update_max_speed(_hspdMod, _vspdMod){
	maxHspd = max(0, maxHspd + _hspdMod);
	maxVspd = max(0, maxVspd + _vspdMod);
}

/// @description Removes and stores away the decimal values for the entity's current hspd and vspd. This 
/// ensures that the entity will never move on a sub-pixel basis, which makes collision a lot more simplified.
function remove_movement_fractions(){
	// Calculate the amount the entity should move relative to the current frame; store any fractional values.
	deltaHspd = hspd * global.deltaTime;
	deltaVspd = vspd * global.deltaTime;
	
	if (hspd == 0) {hspdFraction = 0;}
	// Recalculate the remaining fractional value for horizontal movement
	deltaHspd += hspdFraction;
	hspdFraction = deltaHspd - (floor(abs(deltaHspd)) * sign(deltaHspd));
	deltaHspd -= hspdFraction;

	if (vspd == 0) {vspdFraction = 0;}
	// Recalculate the remaining fractional value for vertical movement
	deltaVspd += vspdFraction;
	vspdFraction = deltaVspd - (floor(abs(deltaVspd)) * sign(deltaVspd));
	deltaVspd -= vspdFraction;
}