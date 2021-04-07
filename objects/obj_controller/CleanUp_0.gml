/// @description Clean Up Weather Object and Camera, Remove Singleton, End Game

if (weather != noone){
	with(weather) {weather_destroy();}
	delete weather;
}

remove_singleton_object();
camera_destroy(cameraID);
game_end();