/// @description Variable Initialization

#region SINGLETON CHECK

if (global.controllerID != noone){
	if (global.controllerID.object_index == object_index){
		instance_destroy(self);
		return;
	}
	instance_destroy(global.controllerID);
}
global.controllerID = id;

#endregion

#region EDITING INHERITED VARIABLES

image_speed = 0;
image_index = 0;
visible = true;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// VARIABLES FOR DRAWING TO THE IN-GAME HUD ////////////////////////////////////////

// Holds the index for the shader used for outlining text/other HUD elements
outlineShader = shd_outline;
// Getting the uniforms for the shader; storing them in local variables
sPixelWidth = shader_get_uniform(outlineShader, "pixelWidth");
sPixelHeight = shader_get_uniform(outlineShader, "pixelHeight");
sOutlineColor = shader_get_uniform(outlineShader, "outlineColor");
sDrawOutline = shader_get_uniform(outlineShader, "drawOutline");

////////////////////////////////////////////////////////////////////////////////////

// VARIABLES FOR THE CAMERA ////////////////////////////////////////////////////////

// Store the created camera's ID for easy reference.
cameraID = -1;

// Holds the target position to move to whenever the camera is unlocked and not following an object.
// The fraction holds the values for the movement until it surpasses one, which will then add/subtract
// a value of one to current camera position. The move speed determines how fast it will reach that position.
targetPosition = [0, 0];
targetFraction = [0, 0];
moveSpeed = 0.25;

// Holds the instance ID for the object being followed by the camera. The deadzone radius is the distance
// from the center of the screen that the camera won't snap the the followed object's position.
curObject = noone;
deadZoneRadius = 8;

// Variables that are involved in handling the screen's shaking effect. The first variable is a 2D vector 
// that holds the center offset for the camera's shake. This is required due to the "dead-zone" in the center 
// of the screen where the player can move, but the camera doesn't follow them. Moving on, the strength is 
// the  magnitude of the shake as ssoon as it starts. The length is how much time is left in the shake. The 
// length is how many seconds the shake will occur for. Finally, the remain holds the remaining shake relative 
// to the initial magnitude and 0.
shakeCenter = [0, 0];
shakeStrength = 0;
shakeLength = 0;
shakeMagnitude = 0;

// A flag that is set to true to move the camera to the newly set object's position without snapping.
newObjectSet = false;

// After initializing all camera variables, create the camera with default aspect ratio/scale. Also,
// set its starting position in the center of the title screen room.
create_camera(160, 90, global.settings[Settings.ResolutionScale]);

////////////////////////////////////////////////////////////////////////////////////

// VARIABLES FOR BACKGROUND MUSIC //////////////////////////////////////////////////

// Holds the index for the current song that is being played in the background. If this value is
// different from the similar global variable, the song will be faded out and swapped to the newly
// set song. The fadeTime variable determines how long the fade out and fade in will be in milliseconds.
curSong = -1;
fadeTime = 300;		// (1000 = 1 second)

// This variable keeps track of how long the loop in the song is to allow for near-seamless looping of
// the game's background music.
loopLength = -1;

// Stores the ID of the song that is returned upon using audio_play_sound(curSong). Allows for adjusting
// the position values for looping the track and adjusting the gain, and other related effects.
songID = noone;

////////////////////////////////////////////////////////////////////////////////////

// VARIABLES FOR THE IN-GAME TIMER /////////////////////////////////////////////////

// Counts to 60 relative to the game's delta time values in order to accurately track the in-game
// playtime. Every second that passes this value is subtracted by one and not intrinsictly set to 0
// in order to be as accurate as possible.
frameTimer = 0;

////////////////////////////////////////////////////////////////////////////////////

#endregion

// FOR TESTING WEATHER
weather = noone;

show_debug_overlay(true);
showDebugInfo = false;
showItems = false;