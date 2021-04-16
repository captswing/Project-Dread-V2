/// @description Executing the Current Scene

// FAILSAFE -- No script was set or no data was placed into the data list, delete the cutscene object
if (sceneScript == NO_SCRIPT || ds_queue_size(sceneData) == 0){
	instance_destroy(self);
	return;
}

// Execute the current cutscene action
script_execute_ext(sceneScript, ds_queue_head(sceneData), 1);