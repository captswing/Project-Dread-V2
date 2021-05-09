/// @description Play the emitter's provided sound effect with an option to loop the emitter's sound effect.
/// It also has the option to smoothly fade in the sound effect at a given number of milliseconds, but it
/// can also be instantaneous by setting the number to 0. Can also be used to resume the sound after the
/// function "emitter_stop_sound" was previously used on said emitter.
/// @param emitterID
/// @param loopSound
/// @param fadeTime
function emitter_play_sound(_emitterID, _loopSound, _fadeTime){
	with(_emitterID){
		if (!audio_is_playing(soundID)){ // Starts up the sound if it wasn't previously playing
			soundID = play_sound_effect_ext(soundIndex, 0, _loopSound, x, y, audio_falloff_linear_distance_clamped, falloffRefDist, falloffMaxDist, falloffFactor); 
		}
		// Sets the sound to fade in from complete silence in a set number of milliseconds
		audio_sound_gain(soundID, get_audio_group_volume(Settings.Sounds), _fadeTime);
		isSoundPlaying = true;
	}
}

/// @description "Stops" the sound by fading its volume to 0. It's still playing in the background, but isn't
/// audible; thus the term "stop_sound" being used for the function.
/// @param emitterID
/// @param fadeTime
function emitter_stop_sound(_emitterID, _fadeTime){
	with(_emitterID){
		if (audio_is_playing(soundID)){ // Only stop the sound if it's actually playing
			audio_sound_gain(soundID, 0, _fadeTime);
			isSoundPlaying = false;
		}
	}
}

/// @description Initializes the variables needed by the emitter in order to properly operate.
/// @param sound
/// @param falloffRefDist
/// @param falloffMaxDist
/// @param falloffFactor
function emitter_create(_sound, _falloffRefDist, _falloffMaxDist, _falloffFactor){
	// Store the sound the emitter will play into a variable
	soundIndex = _sound;
	// Stores the falloff characteristics for the emitter
	falloffRefDist = _falloffRefDist;
	falloffMaxDist = _falloffMaxDist;
	falloffFactor = _falloffFactor;
}

/// @description Updates the position of an object's emitter. This function should be called at the end step
/// event of the object that is associated with the audio emitter.
/// @param emitterID
/// @param xPos
/// @param yPos
function emitter_update_position(_emitterID, _xPos, _yPos){
	with(_emitterID){
		x = _xPos;
		y = _yPos;
	}
}

/// @description Allows the adjustment of the emitter's settings through a single function call. Can change
/// the sound and all of the emitter's 3D audio falloff settings.
/// @param emitterID
/// @param soundIndex
/// @param falloffRefDist
/// @param falloffMaxDist
/// @param falloffFactor
function emitter_update_settings(_emitterID, _soundIndex, _falloffRefDist, _falloffMaxDist, _falloffFactor){
	with(_emitterID){
		// Stops the previously set emitter sound if it was actively playing when this setting was called.
		// Also updates the flag to false to reflect the change.
		if (audio_is_playing(soundID)){
			audio_stop_sound(soundID);
			isSoundPlaying = false;
		}
		// Overwrite all of the necessary variables; updating the sound emitter's current settings.
		soundIndex = _soundIndex;
		falloffRefDist = _falloffRefDist;
		falloffMaxDist = _falloffMaxDist;
		falloffFactor = _falloffFactor;
	}
}