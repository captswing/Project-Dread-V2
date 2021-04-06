/// @description 
/// @param seconds
function cutscene_wait(_seconds){
	timer += global.deltaTime;
	if (timer >= _seconds * global.targetFPS){
		cutscene_end_action();
		timer = 0;
	}
}

/// @description Executes the chunk of textbox functions located in the queue after this function's queue
/// position until the cutscene_end_textbox is at the queue head, or if the queue runs out of data before
/// said function has been reached within the queue. The cutscene and textbox object will be deleted if
/// that does happen, however.
///
/// NOTE --- THIS MUST BE PLACED AT THE BEGINNING OF ANY TEXTBOX CHUNKS WITHIN THE CUTSCENE DATA!!!
///
function cutscene_init_textbox(){
	// First, dequeue this function from the cutscene data queue.
	ds_queue_dequeue(sceneData);
	// Next, get the head of the queue and begin looping through the queue, reading each textbox creation
	// function until either the cutscene queue is emptied (A failsafe) or the function is at the head of
	// the queue that waits for the textboxes to close.
	var _queueHead = ds_queue_head(sceneData);
	while(_queueHead[0] != cutscene_end_textbox){
		// Create the textbox with the function data provided from the queue's head
		cutscene_execute(_queueHead);
		// Dequeue that data and make sure the queue hasn't run dry during this loop. If it does, delete
		// the textbox object and this cutscene managing object.
		ds_queue_dequeue(sceneData);
		if (ds_queue_size(sceneData) == 0){
			instance_destroy(global.textboxID);
			instance_destroy(self);
			break; // Break out of the loop early
		}
		// The queue still isn't empty, move onto the next textbox function.
		_queueHead = ds_queue_head(sceneData);
	}
}

/// @description Waits until the textbox finishes with the information it was provided. After that, the
/// cutscene will continue onward with the next action. 
///
/// NOTE --- THIS MUST BE PLACED AT THE END OF ANY TEXTBOX CHUNKS WITHIN THE CUTSCENE DATA!!!
///
function cutscene_end_textbox(){
	if (!instance_exists(obj_textbox)) {cutscene_end_action();}
}

/// @description Moves an entity object to a given destination, which will prevent the cutscene from moving
/// on to the next action until that condition has been met. Until then, the entity will be moving.
/// @param destX
/// @param destY
/// @param objectID
function cutscene_move_entity(_destX, _destY, _objectID){
	var _endAction, _directionSet;
	_endAction = false;
	_directionSet = directionSet;
	
	with(_objectID){
		// Sets the direction once at the start of the entity movement, which prevent weird spinning issues
		// that can occur when the direction is updated on a frame-by-frame basis.
		if (!_directionSet){
			direction = point_direction(0, 0, sign(_destX - x), sign(_destY - y));
			_directionSet = true;
		}
		// Set the entity's movement based on their current maximum movement speed, relative to the
		// direction they have to move toward in order to reach their destination.
		var _dir = point_direction(x, y, _destX, _destY);
		hspd = lengthdir_x(maxHspd, _dir);
		vspd = lengthdir_y(maxVspd, _dir);
		// After calculating the movement speed, remove fractional values and apply delta time.
		remove_movement_fractions();
		
		// The entity has reached its destinations, lock them onto the desination position and end the action
		if (point_distance(0, 0, deltaHspd, deltaHspd) > point_distance(x, y, _destX, _destY)){
			set_sprite(standSprite, 4);
			x = floor(_destX);
			y = floor(_destY);
			_endAction = true;
			_directionSet = false; // Reset the set direction flag
		} else{ // Entity has not reached their destination; move them and set to moving sprite
			set_sprite(walkSprite, 4);
			x += deltaHspd;
			y += deltaVspd;
		}
	}
	directionSet = _directionSet;
	
	if (_endAction) {cutscene_end_action();}
}