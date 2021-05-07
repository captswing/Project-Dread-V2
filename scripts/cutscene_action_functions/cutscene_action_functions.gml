/// @description Ends the current action and deletes it from the queue of cutscene instruction data. If the
/// element that was destroyed was the final element in the queue, the object will be destroyed and the
/// cutscene will be finished executing.
function cutscene_end_action(){
	ds_queue_dequeue(sceneData);
	if (ds_queue_size(sceneData) == 0){
		instance_destroy(self);
		return;
	}
	var _scriptData = ds_queue_head(sceneData);
	sceneScript = _scriptData[0];
}

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
		script_execute_ext(_queueHead[0], _queueHead, 1);
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
		sceneScript = _queueHead[0];
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
/// @param targetX
/// @param targetY
/// @param pauseForMovement
/// @param objectID
function cutscene_move_entity(_targetX, _targetY, _pauseForMovement, _objectID){
	// Sets the target position and checks if said position has been reached yet. Toggle the flag to end
	// the cutscene action if the said target position has been reached.
	var _positionReached = false;
	with(_objectID){
		if (curState != state_entity_move_to_position){ // Sets the target position and state
			set_cur_state(state_entity_move_to_position);
			targetPosition = [_targetX, _targetY];
		}
		_positionReached = (x == targetPosition[X] && y == targetPosition[Y]);
	}
	
	// The target position has been reached, or the camera will move to where it needs to be while the 
	// cutscene moves on with it next instruction.
	if (!_pauseForMovement || _positionReached) {cutscene_end_action();}
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
		camera_set_target_position(_targetX, _targetY, _moveSpeed);
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
		camera_set_cur_object(_objectID, _moveSpeed, false);
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
/// @param pauseForFade
function cutscene_begin_screen_fade(_fadeColor, _fadeSpeed, _pauseForFade){
	// If somehow the effect handler object doesn't exist, skip this action
	if (global.singletonID[? EFFECT_HANDLER] == noone){
		cutscene_end_action();
		return; // Exit before performing event actions
	}
	
	// Creates the screen fade effect and optionally waits until it is opaque before moving onto the next
	// instruction in the cutscene queue.
	var _fadeFinished = false;
	with(global.singletonID[? EFFECT_HANDLER]){
		create_screen_fade(_fadeColor, _fadeSpeed, INDEFINITE_EFFECT);
		_fadeFinished = (fade.alpha >= 1);
	}
	
	// Ends the action instantly or when the instruction condition is met
	if (!_pauseForFade || _fadeFinished) {cutscene_end_action();}
}

/// @description Tells the active screen fade to begin fading out, which it will not do until this function
/// has been hit in the instructions. This allows for the cutscene to do whatever it needs to do when the 
/// screen is completely black without any worry of the screen fading back in before everything is set up.
/// @param fadeSpeed
/// @param pauseForFade
function cutscene_end_screen_fade(_fadeSpeed, _pauseForFade){
	var _fadeFinished = false;
	with(global.singletonID[? EFFECT_HANDLER]){
		with(fade){ // Tell the fade to begin its fading out animation
			if (opaqueTime == INDEFINITE_EFFECT){
				fadeSpeed = _fadeSpeed;
				fadingOut = true;
			}
		}
		// If the fade has completed its fade-in, the pointer will be set to "noone", which signals to this
		// function that the condition to move onto the next cutscene instruction has been met.
		if (fade == noone) {_fadeFinished = true;}
	}
	
	// Ends the action instantly or when the instruction condition is met
	if (!_pauseForFade || _fadeFinished) {cutscene_end_action();}
}

/// @description Allows for creation of an item during a cutscene. Lasts one frame before moving onto the 
/// next cutscene action.
/// @param x
/// @param y
/// @param name
/// @param quantity
/// @param durability
function cutscene_create_item(_x, _y, _name, _quantity, _durability){
	create_item(_x, _y, _name, _quantity, _durability);
	cutscene_end_action();
}

/// @description Changes the current weather effect to another at a set intensity. This also lasts one frame
/// before moving onto the next curscene action.
/// @param type
/// @param intensity
function cutscene_change_weather(_type, _intensity){
	with(global.singletonID[? EFFECT_HANDLER]) {set_weather(_type, _intensity);}
	cutscene_end_action();
}

/// @description Plays a sound effect at a set volume level. This lasts for one in-game frame before moving
/// onto the next cutscene instruction.
/// @param sound
/// @param volume
function cutscene_play_sound(_sound, _volume){
	play_sound_effect(_sound, _volume, false);
	cutscene_end_action();
}

/// @description Changes the background music to another track. This lasts for one in-game frame before 
/// moving onto the next cutscene instruction. Putting "" will stop the current background track.
/// @param filename
function cutscene_set_background_music(_filename){
	set_background_music(_filename);
	cutscene_end_action();
}

/// @description Adds objects from the room into the map of cutscene objects. These are objects that will be
/// automatically destroyed once the cutscene finishes it's list of instructions. Notably, these objects should
/// be created in the room as long as the event hasn't been completed, and should be located in an area that
/// can't be seen by the player.
/// @param objectID
/// @param key
function cutscene_add_object(_objectID, _key){
	// Checks to make sure the object that is being added to the cutscene objects doesn't already exist
	// within the map of existing cutscene objects.
	if (ds_list_find_index(objectsInMap, _objectID) == -1){
		ds_map_add(cutsceneObjects, _key, _objectID);
		ds_list_add(objectsInMap, _objectID);
	}
	cutscene_end_action();
}

/// @description Destroys an object. This object cannot be a any object found within the singleton map, since
/// deleting those objects would more than likely crash the game instantly or eventually. This lasts for a 
/// single frame before moving onto the next instruction.
/// @param objectID
/// @param executeDestroyEvent
function cutscene_destroy_object(_objectID, _executeDestroyEvent){
	with(_objectID){ // Check if the object isn't a singleton; destroy if it isn't one
		if (!is_valid_singleton()) {instance_destroy(self, _executeDestroyEvent);}
	}
	cutscene_end_action();
}