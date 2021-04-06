/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

image_index = 0;
image_speed = 0;
visible = false;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Creates and stores the queue that will execute the cutscene data contained inside. Doesn't need to be
// deleted since the pointer to this queue is passed into the actual cutscene object, where it will be
// deleted come any error or a successful execution.
sceneData = ds_queue_create();

// TODO -- Add stuff for one-time cutscenes that check for an index in a list for events or something...

#endregion