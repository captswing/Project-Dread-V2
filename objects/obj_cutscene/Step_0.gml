/// @description Executing the Current Scene

// FAILSAFE -- No script was set or no data was placed into the data list, delete the cutscene object
var _script = sceneData[| sceneIndex][0];
if (_script == NO_SCRIPT || ds_list_size(sceneData) == 0){
	instance_destroy(self);
	return;
}

// Execute the current cutscene action
script_execute_ext(_script, sceneData[| sceneIndex], 1);