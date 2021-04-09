/// @description Clean Up Effect Objects and Camera, Remove Singleton, End Game

if (audio_is_playing(songID)){
	audio_stop_sound(songID);
	audio_destroy_stream(songStream);
}

if (weather != noone){
	with(weather) {weather_destroy();}
	delete weather;
	weather = noone;
}

if (fade != noone){
	delete fade;
	fade = noone;
}

remove_singleton_object();
camera_destroy(cameraID);
game_end();