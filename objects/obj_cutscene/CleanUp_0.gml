/// @description Cleaning Up Allocated Memory and Other Data

// Don't clean up uninitialized data if the cutscene object was a duplicate of the existing singleton
if (global.singletonID[? CUTSCENE] != id) {return;}

// Remove this id value from the cutscene singleton; allowing another instance of obj_cutscene to take its place
remove_singleton_object();

// Return all entities back to their previous states and delete the storage grid.
var _length, _states;
_length = ds_grid_height(prevEntityStates);
for (var i = 0; i < _length; i++){
	_states = prevEntityStates[# 1, i];
	with(prevEntityStates[# 0, i]){
		curState = _states[0];
		lastState = _states[1];
	}
}
ds_grid_destroy(prevEntityStates);

// Remove all cutscene objects from memory and from the room itself
var _key, _instance;
_key = ds_map_find_first(cutsceneObjects);
while(!is_undefined(_key)){
	_instance = cutsceneObjects[? _key]; // Delete the object at the key if it still exists
	if (instance_exists(_instance)) {instance_destroy(_instance);}
	_key = ds_map_find_next(cutsceneObjects, _key);
}
ds_map_clear(cutsceneObjects);
ds_map_destroy(cutsceneObjects);

// Next, remove the list containing the IDs in the map, which allows for easy checking if an instance is
// already in the map for cutscene objects.
ds_list_destroy(objectsInMap);

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
with(global.singletonID[? CONTROLLER]) {camera_set_cur_object(global.singletonID[? PLAYER], 0.5, false);}