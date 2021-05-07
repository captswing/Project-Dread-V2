/// @description Cleans Up Data Structure

// Remove the list data from memory
if (ds_exists(sceneData, ds_type_list)) {ds_list_destroy(sceneData);}