/// @description Clean Up Entity

// Remove the list that stores the door's required keys from memory
ds_list_destroy(requiredKeys);

// Finally, call the parent event to clean up all the inherited stuff
event_inherited();