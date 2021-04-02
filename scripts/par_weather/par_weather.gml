/// @description The "Lightweight" object that is inherited by each weather effect. It merely contains empty
/// functions for updating, drawing, and destroying the weather effect object so crashes won't occur when
/// inheriting from this object, but the functions haven't all been overwritten.
function par_weather() constructor{
	// Important flags for weather effects. The first one signals to the handler object when to remove
	// the current weather object from memory, whereas the closing flag tells the weather object when
	// to perform its closing animation -- leading to destruction of the object.
	isDestroyed = false;
	isClosing = false;
	
	// TODO -- Add variables here that alter detectability and noise and shit like that
	
	function weather_update() {}	// Updates any necessary variables used for the weather
	function weather_draw() {}		// Displays the result of the weather effect
	function weather_destroy() {}	// Cleans up any data structures or objects created by the effect
}