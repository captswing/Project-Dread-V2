/// @description Pauses the cutscene for a set duration in seconds. After that, the action ends and the 
/// cutscene moves onto the next instruction for execution.
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
			instance_destroy(global.singletonID[? TEXTBOX]);
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
	if (!instance_exists(global.singletonID[? TEXTBOX])) {cutscene_end_action();}
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
	
	// The entity has reached its destination, end the current action.
	if (_endAction) {cutscene_end_action();}
}

/// @description A simple instruction for the cutscene that teleports an existing entity to the given position.
/// This action will only execute for 1 frame before moving onto the next instructions.
/// @param x
/// @param y
/// @param objectID
function cutscene_set_entity_position(_x, _y, _objectID){
	with(_objectID){
		x = _x;
		y = _y;
	}
	cutscene_end_action();
}

/// @description Another simple instruction for the cutscene system that changes the entity's direction. This
/// action only lasts for 1 in-game frame before moving onto the next instruction.
/// @param direction
/// @param objectID
function cutscene_set_entity_direction(_direction, _objectID){
	with(_objectID) {direction = _direction;}
	cutscene_end_action();
}

/// @description Moves the camera to the desired position at the desired movement speed. Optionally, the
/// cutscene can pause until the camera's position has been reached or it can be bypassed and continue on
/// with the next instruction.
/// @param targetX
/// @param targetY
/// @param moveSpeed
/// @param pauseForMovement
function cutscene_move_camera_position(_targetX, _targetY, _moveSpeed, _pauseForMovement){
	// If somehow the control object doesn't exist, skip this action
	if (global.singletonID[? CONTROLLER] == noone){
		cutscene_end_action();
		return; // Exit before performing event actions
	}
	
	// Sets the target position and checks if said position has been reached yet. Toggle the flag to end
	// the cutscene action if the said target position has been reached.
	var _positionReached = false;
	with(global.singletonID[? CONTROLLER]){
		set_camera_target_position(_targetX, _targetY, _moveSpeed);
		_positionReached = (x == targetPosition[X] && y == targetPosition[Y]);
	}
	
	// The target position has been reached, or the camera will move to where it needs to be while the 
	// cutscene moves on with it next instruction.
	if (!_pauseForMovement || _positionReached) {cutscene_end_action();}
}

/// @description Moves the camera to an object's position and locks it onto said object until another camera
/// action is called in the cutscene. Much like the function above, the wait for movement can be bypassed
/// and allow for multiple cutscene actions to occur simultaneously.
/// @param objectID
/// @param moveSpeed
/// @param pauseForMovement
function cutscene_move_camera_object(_objectID, _moveSpeed, _pauseForMovement){
	// If somehow the control object doesn't exist, skip this action
	if (global.singletonID[? CONTROLLER] == noone){
		cutscene_end_action();
		return; // Exit before performing event actions
	}
	
	// Set the object the camera wil follow and wait for the position to be reached. The position is reached
	// when the flag newObjectSet is false while the curObject variable stores a valid ID for an object.
	var _positionReached = false;
	with(global.singletonID[? CONTROLLER]){
		set_camera_cur_object(_objectID, _moveSpeed, false);
		_positionReached = (!newObjectSet && curObject != noone);
	}
	
	// The entity has been reached and the camera has been locked onto them OR the movement wait was bypassed
	// and the cutscene will continue on before the camera has hit its required position.
	if (!_pauseForMovement || _positionReached) {cutscene_end_action();}
}

/// @description Sets the camera to a given position instantly without any smooth movement. Useful for fading 
/// out and then snapping the position to where the camera should be easily, for example.
/// @param x
/// @param y
function cutscene_set_camera_position(_x, _y){
	// If somehow the control object doesn't exist, skip this action
	if (global.singletonID[? CONTROLLER] == noone){
		cutscene_end_action();
		return; // Exit before performing event actions
	}
	
	// Place the camera at the desired position and move onto the next action
	with(global.singletonID[? CONTROLLER]){
		// NOTE -- If target position isn't set to the position the camera won't stay locked at it
		targetPosition = [_x, _y];
		curObject = noone;
		x = _x;
		y = _y;
	}
	cutscene_end_action();
}

/// @description Causes a color fade-in on the screen of a given color, speed, opaque time, as well as an
/// optional flag that makes the cutscene queue wait for the fade to become fully opaque before moving onto
/// the next instruction. Otherwise, it'll move onto the next instruction the frame after the fade is created.
/// @param fadeColor
/// @param fadeSpeed
/// @param opaqueTime
/// @param pauseForFade
function cutscene_screen_fade(_fadeColor, _fadeSpeed, _opaqueTime, _pauseForFade){
	// If somehow the control object doesn't exist, skip this action
	if (global.singletonID[? CONTROLLER] == noone){
		cutscene_end_action();
		return; // Exit before performing event actions
	}
	
	// Creates the screen fade effect and optionally waits until it is opaue before moving onto the next
	// instruction in the cutscene queue.
	var _fadeFinished = false;
	with(global.singletonID[? CONTROLLER]){
		create_screen_fade(_fadeColor, _fadeSpeed, _opaqueTime);
		_fadeFinished = (fade.alpha >= 1);
	}
	
	// Ends the action instantly or when the instruction condition is met
	if (!_pauseForFade || _fadeFinished) {cutscene_end_action();}
}

/// @description Allows for creation of an item during a cutscene. Lasts one frame before moving onto the next action
/// @param x
/// @param y
/// @param itemName
/// @param quantity
/// @param durability
function cutscene_create_item(_x, _y, _itemName, _quantity, _durability){
	create_item(_x, _y, _itemName, _quantity, _durability);
	cutscene_end_action();
}

/// @description
/// @param sound
//function cutscene_play_sound(_sound){
	//audio_play_sound(_sound, 0, false);
//}