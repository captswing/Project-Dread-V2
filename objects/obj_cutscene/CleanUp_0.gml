/// @description Cleaning Up Allocated Memory and Other Data

// Remove this id value from the cutscene singleton; allowing another instance of obj_cutscene to take its place
remove_singleton_object();

// Removes the queue data structure from memory
ds_queue_destroy(sceneData);

// Delete the cutscene trigger if a valid event flag was set for the trigger. Invalid event flags are for
// cutscenes and event that will never disappear.
with(parentTrigger){
	if (eventFlagIndex >= 0 && set_event_flag(eventFlagIndex, true)){
		instance_destroy(self);
	}
}
parentTrigger = noone;

// Return to the state the game was in when the cutscene object was created. Also, move the camera back to
// the player object if it isn't already following the player at the end of the cutscene instructions.
set_game_state(prevGameState, true);
with(global.singletonID[? CONTROLLER]) {set_camera_cur_object(global.singletonID[? PLAYER], 0.5, false);}