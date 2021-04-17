/// @description Clean Up Music Stream and Camera, Remove Singleton, End Game

// Don't clean up uninitialized data if the controller object was a duplicate of the existing singleton
if (global.singletonID[? CONTROLLER] != id) {return;}

// Remove the audio stream created for playing the current background song if a song is currently being
// streamed in and played from an external audio file.
if (audio_is_playing(songID)){
	audio_stop_sound(songID);
	audio_destroy_stream(songStream);
}

// Removing id from singleton variable, destroy the camera created on startup, and end the game
remove_singleton_object();
camera_destroy(cameraID);
game_end();