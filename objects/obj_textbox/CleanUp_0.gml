/// @description Cleaning Actor Data From Memory and Textbox Data; Restoring Entity States

#region REMOVING INSTANCE DATA/RESTORING GAME STATE

// First, remove the reference to the instance id of this textbox
global.textboxID = noone;

if (!instance_exists(obj_cutscene)){
	global.gameState = GameState.InGame;
}

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