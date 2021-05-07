/// @description A simple "lightweight" object that fades in a color at a determinate speed, which will then
/// cover the whole screen for a set amount of time before fading out, which will signal to whatever object
/// that created this one to delete it. Otherwise, memory leaks will begin...
/// @param color
/// @param speed
/// @param opaqueTime
function obj_fade_screen(_color, _speed, _opaqueTime) constructor{
	// The characteristics of how the fade will appear on-screen. The first variable controls the color the
	// screen will fade into, the speed determines how fast that color will appear and disappear, and the
	// opaque time determines how long the screen will remain the set color. (60 = 1 second)
	fadeColor = _color;
	fadeSpeed = _speed;
	opaqueTime = _opaqueTime;
	
	// What controls the alpha's fading in and out, as well as how visible the color is currently on screen.
	fadingOut = false;
	alpha = 0;
	
	/// @description Fades the screen into and out of its set color at a pre-determined speed. Once the color
	/// has fully faded in, the timer to remain opaque will count down, and once it reaches zero the screen
	/// will begin to fade out of the color.
	function fade_update(){
		alpha += fadingOut ? -fadeSpeed * global.deltaTime : fadeSpeed * global.deltaTime;
		if (alpha > 1 && !fadingOut){ // Remain opaque until the timer runs outs
			opaqueTime -= global.deltaTime;
			if (opaqueTime != INDEFINITE_EFFECT && opaqueTime <= 0){ // Begin the fade out
				fadingOut = true;
			}
			alpha = 1; // Prevent the alpha from going above 1
		} else if (alpha < 0 && fadingOut){
			alpha = 0; // Prevent the alpha from going negative
		}
	}
}