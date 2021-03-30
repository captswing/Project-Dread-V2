/// @description Cleaning Data Structure Out If Necessary. Unpausing Entities

// Prevents the copies of this object that were attempting to be made from crashing the game
if (global.textboxID != id){
	return;
}
// Reset the singleton variables
global.textboxID = noone;

// Loops until the queue is emptied of textbox objects
while(ds_queue_size(textboxes) > 0){
	var _textbox = ds_queue_head(textboxes);
	ds_queue_dequeue(textboxes);
	delete _textbox; // Removes it from memory
}
// Finally, delete the data structure after clearing it out
ds_queue_destroy(textboxes);

// Pause all entities that are active in the room
with(par_dynamic_entity) {set_cur_state(lastState);}