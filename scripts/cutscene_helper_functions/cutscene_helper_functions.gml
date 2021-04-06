/// @description Ends the current action and deletes it from the queue of cutscene instruction data. If the
/// element that was destroyed was the final element in the queue, the object will be destroyed and the
/// cutscene will be finished executing.
function cutscene_end_action(){
	ds_queue_dequeue(sceneData);
	if (ds_queue_size(sceneData) == 0){
		instance_destroy(self);
	}
}

/// @description Executes a cutscene command, which can has any number of arguments associated with it. This
/// is the only way that game maker can do that with the script_execute function, unfortunately...
/// @param array
function cutscene_execute(_array){
	var _totalArgs = array_length(_array) - 1;
	
	switch(_totalArgs){
		case 0: // The script contains no arguments
			script_execute(_array[0]);
			break;
		case 1: // The script contains one argument
			script_execute(_array[0], _array[1]);
			break;
		case 2: // The script contains two arguments
			script_execute(_array[0], _array[1], _array[2]);
			break;
		case 3: // The script contains three arguments
			script_execute(_array[0], _array[1], _array[2], _array[3]);
			break;
		case 4: // The script contains four arguments
			script_execute(_array[0], _array[1], _array[2], _array[3], _array[4]);
			break;
		case 5: // The script contains five arguments
			script_execute(_array[0], _array[1], _array[2], _array[3], _array[4], _array[5]);
			break;
	}
}