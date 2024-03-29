/// @description Calling Current State Function/Executing General Code

// Execute the method containing the current state's code.
if (curState != NO_SCRIPT) {script_execute(curState);}

// Don't allow the entity to regenerate their health or count down their invulnerability timer during a 
// cutscene, a menu being currently opened, or the game itself being completely paused.
if (global.gameState != GameState.InGame){
	if (isHit && !drawSprite) {drawSprite = true;}
	return;
}

// Counting down the entity's invulnerability timer for when they've been hit by an attack. It causes their
// current sprite to flicker until the timer is finished counting down, which then make them vulnerable to
// attacks once again.
if (isHit){
	drawSprite = choose(true, false);
	recoveryTimer += global.deltaTime;
	if (recoveryTimer >= timeToRecover){
		recoveryTimer = 0;
		drawSprite = true;
		isHit = false;
	}
}

// Regenerating hitpoints based on a ratio of amount regenerated divided by the time in seconds
// that the hitpoints regenerates said amount. Allows for any speed of hitpoint regeneration.
if (hpRegenAmount > 0 && regenSpeed > 0 && hitpoints < maxHitpoints){
	hpRegenFraction += ((hpRegenAmount / regenSpeed) * global.deltaTime) / 60;
	if (hpRegenFraction >= 1){
		var _healthGained = floor(hpRegenFraction);
		entity_update_hitpoints(_healthGained);
		hpRegenFraction -= _healthGained;
	}
}