/// @description Cleans Up Allocated Memory

// Don't clean up uninitialized data if the control info object was a duplicate of the existing singleton
if (global.singletonID[? CONTROL_INFO] != id) {return;}

// Clean up data for all existing control information
control_info_clear_all();
ds_list_destroy(controlData);