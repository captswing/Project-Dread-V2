/// @description Handling General Code/Counting Down Accuracy Penalty

// Call the parent event to run its code
event_inherited();

// Handling the accuracy penalty, which is counted down to zero when the player isn't holding the fire weapon
// key down. This prevents just holding the fire button for any gun without consequence. An except to holding
// down the key while the penalty is lowered is when the character is reloading; during so the penalty will
// lower itself.
if ((!keyUseWeapon && fireRateTimer <= 0) || curState == player_state_weapon_reload){
	accuracyPenalty -= 0.25 * global.deltaTime;
	if (accuracyPenalty < 0) {accuracyPenalty = 0;}
}