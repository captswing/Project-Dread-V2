/// @description Cleaning Up Allocated Memory and Other Data

#region REMOVING SINGLETON ID/RESTORING GAME STATE

// Remove this id value from the textbox singleton; allowing another instance of obj_textbox to take its place
remove_singleton_object();

// Restore the game state only if the priority flag allows it.
set_game_state(GameState.InGame, (global.singletonID[? CUTSCENE] == noone));

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

// Finally, remove the textbox list from memory
ds_list_destroy(textboxData);

#endregion