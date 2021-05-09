/// @description Cleaning Up Allocated Memory and Other Data

#region REMOVING SINGLETON ID/RESTORING PLAYER STATE

// Don't clean up uninitialized data if the textbox object was a duplicate of the existing singleton
if (global.singletonID[? TEXTBOX] != id) {return;}

// Restore the player's states from before the textbox was opened and initialized, but don't do that if a
// cutscene is currently happening.
if (global.gameState == GameState.InGame){
	var _state = prevPlayerState;
	with(global.singletonID[? PLAYER]){
		curState = _state[0];
		lastState = _state[1];
	}
}

// Remove this id value from the textbox singleton; allowing another instance of obj_textbox to take its place
remove_singleton_object();

#endregion

#region FREEING ACTOR DATA FROM MEMORY

// Find the first and last indexes for the actor data, which will be used to loop through all the 
// data for clearing it out of memory.
var _actor, _lastIndex;
_actor = ds_map_find_first(actorData);
_lastIndex = ds_map_find_last(actorData);
while(_actor != _lastIndex){ // Loop through all the actor data and delete each one
	delete actorData[? _actor];
	_actor = ds_map_find_next(actorData, _actor);
}
// After clearing the memory out, clear and delete the map from memory
ds_map_clear(actorData);
ds_map_destroy(actorData);

// Next, remove the textbox list from memory
ds_list_destroy(textboxData);

// Finally, remove the decision and event data map from memory
ds_map_destroy(decisionData);

#endregion