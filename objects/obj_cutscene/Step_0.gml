/// @description Executing the Current Scene

// FAILSAFE -- No data was placed into the data list, delete the cutscene object
if (ds_queue_size(sceneData) == 0){
	instance_destroy(self);
	return;
}

// Execute the current cutscene action
cutscene_execute(ds_queue_head(sceneData));