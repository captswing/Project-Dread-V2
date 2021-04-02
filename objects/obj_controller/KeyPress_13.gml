/// @description FOR EASY TESTING

if (weather != noone){
	var _isDestroyed = false;
	with(weather){
		_isDestroyed = isDestroyed;
		if (!isDestroyed){
			lerpProgress = 0;
			isClosing = true;
		}
	}
	if (_isDestroyed){
		delete weather;
		weather = noone;
	}
} else{
	weather = new obj_weather_fog(3, 0.4, 0.5, 2.5, 0.5, 0.9);
}

//create_textbox("This is a test textbox! Hopefully nothing crashes...", Actor.Claire);
//create_textbox("A transition shouldn't occur between the last textbox and this one...", Actor.Claire);
//create_textbox("And this is an actor with no data associated with them! Hopefully the colors are correct...", Actor.None);