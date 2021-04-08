/// @description Clean Up Effect Objects and Camera, Remove Singleton, End Game

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