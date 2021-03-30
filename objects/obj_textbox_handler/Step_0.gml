/// @description Updating Textbox at the Head of the Queue

// Handling the opening/closing of the textbox on the screen. It works based on the position of this object
// and its image transparency to allow the textbox itself to be translated and faded in/faded out.
if (animateState != NO_ANIMATE){
	image_alpha = clamp(image_alpha + animateSpeed * animateState * global.deltaTime, 0, 1);
	y += (yTarget - y) * 2 * animateSpeed * global.deltaTime;
	if ((image_alpha == 0 || image_alpha == 1) && y - yTarget <= 1){
		// Switch the animation to reopen the textbox if more data remains inside the queue. 
		// Otherwise, delete the textbox handler and end the dialogue.
		if (animateState == BACKWARD_ANIMATE){
			var _textbox = ds_queue_head(textboxes);
			if (!is_undefined(_textbox)){
				ds_queue_dequeue(textboxes);
				delete _textbox; // Removes it from memory
			}
			// If the queue is empty, delete the handler
			if (ds_queue_size(textboxes) == 0){
				instance_destroy(self);
			}
			animateState = FORWARD_ANIMATE;
			yTarget = WINDOW_HEIGHT - 65;
			return; // Exit before the animate state gets reset
		}
		animateState = NO_ANIMATE;
	}
	return; // Prevent textbox updates during animation
}

// Update the currently active textbox
var _reopenTextbox = false;
with(ds_queue_head(textboxes)){
	update_textbox(); // Handle text scrolling and keyboard input
	_reopenTextbox = isDestroyed;
}
// Begin animating to the next textbox within the queue OR just swap to the next textbox instantly
if (_reopenTextbox){
	animateState = BACKWARD_ANIMATE;
	yTarget = WINDOW_HEIGHT + 25;
}