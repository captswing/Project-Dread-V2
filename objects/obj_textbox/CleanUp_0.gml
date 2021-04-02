/// @description Cleaning Actor Data From Memory and Textbox Data; Restoring Entity States

#region REMOVING INSTANCE DATA/RESTORING ENTITY STATES

// First, remove the reference to the instance id of this textbox
global.textboxID = noone;

// Free the entities from their locked states
with(global.playerID) {set_cur_state(lastState);}

#endregion

#region FREEING ACTOR DATA FROM MEMORY

// Find the first and last indexes for the actor data, which will be used to loop through all the 
// data for clearing it out of memory.
var _actor, _lastIndex;
_actor = ds_map_find_first(actorData);
_lastIndex = ds_map_find_last(actorData);
while(_actor != _lastIndex){ // Loop through all the actor data and delete it
	delete actorData[? _actor];
	_actor = ds_map_find_next(actorData, _actor);
}
// After clearing the memory out, clear and delete the map from memory
ds_map_clear(actorData);
ds_map_destroy(actorData);

// Finally, remove the textbox list from memory
ds_list_destroy(textboxData);

#endregion