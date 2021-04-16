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

// Two variables that tie into the event flags that will be crucial for disabling/enabling certain cutscene
// triggers, cutscene objects, and so on. The first variable points to a list that stores all of the requied 
// flags that must be set in order for this event to be active in the room. This list can be empty if no flags
// need to be set before this trigger's flag is set. Meanwhile, the setting variable stores the index into the
// event flag list that its flag corresponds to.
requiredFlags = ds_list_create();
eventFlagIndex = -1;

#endregion