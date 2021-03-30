/// @description Unique Variable Initialization

#region SINGLETON CHECK

if (global.textboxID != noone){
	if (global.textboxID.object_index == object_index){
		instance_destroy(self);
		return;
	}
	instance_destroy(global.textboxID);
}
global.textboxID = id;

#endregion

#region EDITING INHERITED VARIABLES

image_index = 0;
image_alpha = 0;
image_speed = 0;
visible = true;

// Start the y-position off-screen for the transition
x = 0;
y = WINDOW_HEIGHT + 10;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// The queue that handles the dialogue that will be shown to the player during this "conversation." The 
// object will be active until this queue runs out of Textbox objects to activate. Once the queue is empty,
// the object is deleted and gameplay resumes.
textboxes = ds_queue_create();
create_dialogue(textboxes, TEST_DIALOGUE);

// 
yTarget = WINDOW_HEIGHT - 65;

// Variables for handling the animation of the textbox on the screen. The first variable controls whether the
// the animation will play out forward or in reverse, and the second variable handles the speed of the animation;
// both the fading and translation animations.
animateState = FORWARD_ANIMATE;
animateSpeed = 0.1;

#endregion

// Pause all entities that are active in the room
with(par_dynamic_entity) {set_cur_state(NO_SCRIPT);}