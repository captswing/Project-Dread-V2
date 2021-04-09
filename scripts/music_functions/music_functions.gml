/// @description Begins the fadeaway that will lead into changing the background song, which isn't caused by
/// this function unless there was no song playing previously. In that case, this function will change the
/// background music instantly.
/// @param filename
/// @param songLength
/// @param loopLength
function set_background_music(_filename, _songLength, _loopLength){
	with(global.singletonID[? CONTROLLER]){
		if (songID == noone){ // No previous song was playing, instantly start playing the music
			change_background_music(_filename, _songLength, _loopLength);
		} else{ // Another song was playing previously, begin the fade-out of the song into the new one
			audio_sound_gain(songID, 0, songFadeTime);
			// Keep track of the next song's filepath, song, and loop length for when the song actually changes.
			changingSong = true; // Enable flag that begins checking for the song to complete its fadeaway
			nextSongPath = _filename;
			nextSongLength = _songLength;
			nextSongLoopLength = _loopLength;
		}
	}
}

/// @description The function that actually changes the song to the next one. It removes the previous song's
/// stream from memory and starts up the stream for the next song. However, if the provided file doesn't
/// exist the music will simply stop playing.
/// @param filename
/// @param songLength
/// @param loopLength
function change_background_music(_filename, _songLength, _loopLength){
	// Make sure the file exists before attempting to create an audio stream from it. If no file with that
	// name exists in the music folder, simply reset all music-related variables and don't play anything.
	if (file_exists("music/" + _filename)){
		songStream = audio_create_stream("music/" + _filename);
		// Begin the next song that will play, storing its ID in a variable for easy manipulation of its playback.
		songID = audio_play_sound(songStream, 100, false);
		audio_sound_gain(songID, 0, 0); // Start the song out silent and fade in
		audio_sound_gain(songID, get_audio_group_volume(Settings.Music), songFadeTime);
		// After, store the length of the entire song and the length of its looping portion
		songLength = _songLength;
		songLoopLength = _loopLength;
	} else{
		songStream = noone;
		songID = noone;
		songLength = 0;
		songLoopLength = 0;
	}
	// Finally, reset the flag that enables the song to change in the first place
	changingSong = false;
}

/// @description The function that should be called every frame within a controller object; as it is responsible
/// for checking when the previous song has completed its fade out, which will then begin the next song and
/// its respective fade in. On top of that, this function also loops the song with near-seamless playback.
function update_background_music(){
	if (changingSong && audio_sound_get_gain(songID) == 0){
		if (songID != noone){ // Delete the previous audio stream from memory
			audio_stop_sound(songID);
			audio_destroy_stream(songStream);
		}
		change_background_music(nextSongPath, nextSongLength, nextSongLoopLength);
		// Reset the storage variables responsible for holding what song will play next.
		nextSongPath = "";
		nextSongLength = 0;
		nextSongLoopLength = 0;
	} else{
		var _songPosition = audio_sound_get_track_position(songID);
		if (_songPosition >= songLength){ // Looping when the song's length is exceeded
			audio_sound_set_track_position(songID, _songPosition - songLoopLength);
		}
	}
}