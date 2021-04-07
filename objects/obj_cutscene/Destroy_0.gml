/// @description Cleaning Up Allocated Memory and Other Data

// Remove this id value from the cutscene singleton; allowing another instance of obj_cutscene to take its place
remove_singleton_object();

// Removes the queue data structure from memory
ds_queue_destroy(sceneData);

// Return to the state the game was in when the cutscene object was created. Also, move the camera back to
// the player object if it isn't already following the player at the end of the cutscene instructions.
set_game_state(prevGameState, true);
with(global.singletonID[? CONTROLLER]) {set_camera_cur_object(global.singletonID[? PLAYER], 0.5, false);}