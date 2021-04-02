/// @description Clean Up Current Weather Effect and the Camera

if (weather != noone){
	with(weather) {weather_destroy();}
	delete weather;
}

camera_destroy(cameraID);
game_end();