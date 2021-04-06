/// @description Clean Up Data Structures and Resetting Game State/Camera Stuff

// Reset the singleton variable value
global.cutsceneID = noone;

// Removes the queue data structure from memory
ds_queue_destroy(sceneData);

// Return to the state the game was in when the cutscene object was created. Also, move the camera back to
// the player object if it isn't already following the player at the end of the cutscene instructions.
set_game_state(prevGameState, true);
with(global.controllerID) {set_camera_cur_object(global.playerID, 0.5, false);}