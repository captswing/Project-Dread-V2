/// @description Clean Up Current Weather Effect and the Camera

with(weatherEffect) {Destroy();}
delete weatherEffect;

camera_destroy(cameraID);
game_end();