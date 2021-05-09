/// @description Update Camera Position, Listener Position, and Delta Time

// Update camera's position
camera_update_position();

// If no player character object exists, set the audio listener position to the camera's current position
if (global.singletonID[? PLAYER] == noone) {audio_listener_position(x, y, 0);}

// Set delta time for the current frame
global.deltaTime = (delta_time / 1000000) * global.targetFPS;