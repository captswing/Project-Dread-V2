/// @description Changes the background music to another song. This initiates the smooth fade out of
/// current song, which leads to the the smooth fading in of the new track.
/// @param song
/// @param loopLength
function set_background_music(_song, _loopLength){
	with(global.controllerID){
		// Don't change the song if it isn't actually being changed
		if (curSong != _song){
			global.curSong = _song;
			global.loopLength = _loopLength;
			// Fade out whatever song is currently playing
			audio_sound_gain(curSong, 0, fadeTime);
		}
	}
}

/// @description Gets the volume of the background music, which is calculated based on a ratio between
/// the current master volume and 100. Then, that is multiplied by the current volume set for the music,
/// which is then also divided by 100 to get the normalized value between 0 and 1.
function get_background_music_volume(){
	return (global.settings[Settings.Music] * (global.settings[Settings.Master] / 100)) / 100;
}

/// @description Automatically plays the current background song with near-seamless looping. Also, it allows
/// for automatic switch of the background music with a smooth fade-in and fade-out effect to the next track.
function update_background_music(){
	if (curSong != global.curSong){ // Swapping background song
		if (audio_sound_get_gain(curSong) <= 0){
			audio_stop_sound(curSong);
			songID = audio_play_sound(global.curSong, 1000, false);
			// Set the song to fade in smoothly
			audio_sound_gain(songID, 0, 0);
			audio_sound_gain(songID, get_background_music_volume(), fadeTime);
			// Update the variables for the song and its loop length after transitioning to the 
			// new background music
			curSong = global.curSong;
			loopLength = global.loopLength;
		}
	} else{ // Playing/looping the current song
		var _position = audio_sound_get_track_position(songID);
		if (_position >= loopLength){
			audio_sound_set_track_position(songID, _position - loopLength);
		}
		// Automatically pausing and unpausing the song when it fades out or fades in whenever the functions
		// pause_background_music or unpause_background_music are used.
		if (audio_sound_get_gain(curSong) <= 0){
			audio_pause_sound(songID);
		} else if (audio_is_paused(songID)){
			audio_resume_sound(songID);
		}
	}
}

/// @description Pauses the background music by smoothly fading out the current song. The time it takes for
/// fading out can be set to whatever value is required (in milliseconds).
/// @param fadeTime
function pause_background_music(_fadeTime){
	audio_sound_gain(curSong, 0, _fadeTime);
}

/// @description Unpauses the background music by smoothly fading in the current song. The time it takes for
/// fading in can be set to whatever value is required (in milliseconds).
/// @param fadeTime
function unpause_background_music(_fadeTime){
	audio_sound_gain(curSong, get_background_music_volume(), _fadeTime);
}