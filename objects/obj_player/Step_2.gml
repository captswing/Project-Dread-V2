/// @description Set Audio Listener Position to Player's Position/Handle Footstep Sounds

// Lock the listener to the player's x and y coordinates when in-game
if (global.gameState == GameState.InGame){
	audio_listener_position(x, y, 0);
	global.listenerPosition = [x, y];
}

var _falloffDist = 150;

// Don't bother worrying about footstep sounds if the player isn't in their walking/running animations.
// When the animation isn't the walking or running one, always step the step sound to be able to play.
if (sprite_index != walkSprite){
	playStepSound = true;
	return;
}

// If the distance that the entity is from the audio listener is greater than the maximum falloff distance
// the audio won't be played -- saving processing time.
var _distanceFromListener = point_distance(x, y, global.listenerPosition[X], global.listenerPosition[Y]);
if (_distanceFromListener > _falloffDist){
	return;
}

// Attempt to play a footstep sound effect for the material beneath the player while they're in motion. The
// sounds can only play during the walking/running animations, and won't play during another other animation.
var _localFrame = floor(localFrame);
if (playStepSound && collisionTilemap != -1 && (_localFrame == rightFootIndex || _localFrame == leftFootIndex)){
	var _tileID = tilemap_get_at_pixel(collisionTilemap, x, y);
	if (_tileID != -1){ // If a valid tile exists beneath the player's current position
		playStepSound = false; // Prevents the sound for playing every frame that the animation is on the footstep frame
		var _volume, _pitch, _sound;
		_volume = random_range(0.15, 0.75);
		_pitch = 1 + random_range(-0.05, 0.05);
		_sound = play_sound_effect_ext(footstepSounds[_tileID - 1], _volume, false, x, y, audio_falloff_linear_distance_clamped, 50, 150, 1);
		audio_sound_pitch(_sound, _pitch);
	}
}

// Resetting the flag that allows the footstep effect to be played
if (!playStepSound && _localFrame != rightFootIndex && _localFrame != leftFootIndex){
	playStepSound = true;
}