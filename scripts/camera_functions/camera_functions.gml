/// @description Creates the camera object that allows the game to be viewed through its relative window port. 
/// Otherwise, the game would just be a black, empty square and that's no fun.
/// @param x
/// @param y
/// @param scale
function create_camera(_x, _y, _scale){
	if (cameraID == -1){ // Only attempt to create a camera if one doesn't currently exist
		// Snap to the camera's set starting position
		x = floor(_x);
		y = floor(_y);
		// Create the camera with a given viewport resolution; store the camera's ID in a variable
		cameraID = camera_create();
		camera_set_view_size(cameraID, WINDOW_WIDTH, WINDOW_HEIGHT);
		surface_resize(application_surface, WINDOW_WIDTH, WINDOW_HEIGHT);
		// After setting up the camera's resolution and aspect ratio, build a projection and view matrix for it.
		camera_set_view_mat(cameraID, matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0));
		camera_set_proj_mat(cameraID, matrix_build_projection_ortho(WINDOW_WIDTH, WINDOW_HEIGHT, 1, 10000));
		// Finally, set the window's size based on the current scaling factor
		set_camera_window_size(_scale);
	}
}

/// @description Sets the window's size based on a scaling factor relative to its currently set aspect ratio.
/// @param scale
function set_camera_window_size(_scale){
	var _windowDimensions = [camera_get_view_width(cameraID) * floor(_scale), camera_get_view_height(cameraID) * floor(_scale)];
	// After calculating the scale value for the window's dimensions, set the position and resize
	window_set_position(round((display_get_width() - _windowDimensions[X]) / 2), round((display_get_height() - _windowDimensions[Y]) / 2));
	window_set_size(_windowDimensions[X], _windowDimensions[Y]);
	// Finally, update the GUI scaling to match the window's new scale
	display_set_gui_maximize(_scale, _scale, 0, 0);
}

/// @description Sets the curObject variable to the ID for the object the camera will follow. Instead of 
/// instantly locking on, however, the camera can optionally set a flag that enables the camera to smoothly 
/// reach whatever position the followed object is at before resetting to default movement.
/// @param objectID
/// @param moveSpeed
/// @param snapToTarget
function set_camera_cur_object(_objectID, _moveSpeed, _snapToTarget){
	if (id != global.controllerID || curObject == _objectID || !instance_exists(_objectID)){
		return; // Stop non-camera object from executing the function. Also, prevent invalid IDs from being followed
	}
	// Move into the controller object and set its target position or snap to target if required
	curObject = _objectID;
	if (!_snapToTarget){ // Smooth movement; set target position and temporarily unlock camera
		newObjectSet = true; // Prevent curObject from being set to noone by the target position function
		set_camera_target_position(_objectID.x, _objectID.y, _moveSpeed);
	} else{ // Instantly lock the camera to the object's position
		x = floor(_objectID.x);
		y = floor(_objectID.y);
	}
}

/// @description Applies a shake effect to the camera with a strength and time of shake being equal to the 
/// values provided in the arguments of the function call. If the strength isn't higher than the current 
/// shake's magnitude it will not be overwritten. (1 second = 60)
/// @param strength
/// @param length
function set_camera_shake(_strength, _length){
	if (id != global.controllerID){
		return; // The object that called this function isn't the camera; don't execute
	}
	// Only overwrite the current camera shake if the intensity of the new shake is greater than the current.
	if (shakeMagnitude < _strength){
		shakeMagnitude = _strength;
		shakeStrength = _strength;
		shakeLength = _length;
	}
}

/// @descriptionSets the target position for an unlocked camera to move to. If the camera isn't already
/// unlocked it will be unlocked in order to move to the provided position. This is useful during cutscenes.
/// @param targetX
/// @param targetY
/// @param moveSpeed
function set_camera_target_position(_targetX, _targetY, _moveSpeed){
	if (id != global.controllerID){
		return; // The object that called this function isn't the camera; don't execute
	}
	// Remove any decimals from the target positions. Also prevent the move speed from being less than 0.
	targetPosition = [floor(_targetX), floor(_targetY)];
	moveSpeed = max(0.1, _moveSpeed);
	// Always unlock the camera if not moving to followed object's position
	if (!newObjectSet) {curObject = noone;}
}

/// @description Gets the top-left x-position of the screen in the current room's coordinates since the 
/// actual camera's position is in the center of the screen.
function get_camera_x(){
	return global.controllerID.x - (WINDOW_WIDTH / 2);
}

/// @description Gets the top-left y-position of the screen in the current room's coordinates since the
/// actual camera's position is in the center of the screen.
function get_camera_y(){
	return global.controllerID.y - (WINDOW_HEIGHT / 2);
}

/// @description Updates the position of the camera used the currently desired movement method, whether that be
/// free and smooth movement while unlocked, or a locked-on movement with a deadzone in the center.
function update_camera_position() {
	// Calculating the bounds of the camera relative to the edges of the room
	var _halfWidth, _halfHeight;
	_halfWidth = WINDOW_WIDTH / 2;
	_halfHeight = WINDOW_HEIGHT / 2;

	if (!newObjectSet && curObject != noone){ // Camera movement when locked onto an object
		var _newPosition = [0, 0];
		with(curObject){ // Get the object's current position; storing it in a vector
			_newPosition[X] = x;
			_newPosition[Y] = y;
		}
	
		// Factors in the current offset of the camera shake to avoid any weird bugs 
		// with deadzone boundaries.
		var _deadZone = deadZoneRadius;
	
		// Horizontal camera movement
		if (x < _newPosition[X] - _deadZone){ // Moving the camera to the left
			x = _newPosition[X] - _deadZone;
			shakeCenter[X] = x; // Update the camera shake's origin point's X position
		} else if (x > _newPosition[X] + _deadZone){ // Moving the camera to the right
			x = _newPosition[X] + _deadZone;
			shakeCenter[X] = x; // Update the camera shake's origin point's X position
		}
		// Vertical camera movement
		if (y < _newPosition[Y] - _deadZone){ // Moving the camera upward
			y = _newPosition[Y] - _deadZone;
			shakeCenter[Y] = y; // Update the camera shake's origin point's Y position
		} else if (y > _newPosition[Y] + _deadZone){ // Moving the camera downward
			y = _newPosition[Y] + _deadZone;
			shakeCenter[Y] = y; // Update the camera shake's origin point's Y position
		}
	} else{ // Camera movement when unlocked or moving to followed object
		var _moveSpeed = moveSpeed * global.deltaTime;
		// Smooth horizontal movement
		targetFraction[X] += (targetPosition[X] - x) * _moveSpeed;
		if (abs(targetFraction[X]) >= 1){ // Prevents any half-pixel movement on the x-axis.
			var _amountToMove = floor(targetFraction[X]);
			targetFraction[X] -= _amountToMove;
			x += _amountToMove;
		}
		// Smooth vertical movement
		targetFraction[Y] += (targetPosition[Y] - y) * _moveSpeed;
		if (abs(targetFraction[Y]) >= 1){ // Prevents any half-pixel movement on the y-axis.
			var _amountToMove = floor(targetFraction[Y]);
			targetFraction[Y] -= _amountToMove;
			y += _amountToMove;
		}
	
		// Check if the camera has reached its final position. Reset fraction variables and lock position if so.
		if (point_distance(x, y, targetPosition[X], targetPosition[Y]) < moveSpeed){
			x = targetPosition[X];
			y = targetPosition[Y];
			targetFraction = [0, 0];
			// Reset the flag for moving to a newly followed object to return to default movement.
			if (curObject != noone){
				newObjectSet = false;
			}
		}
	
		// When the camera is unlocked the shake's origin point will always be the center of the screen
		shakeCenter[X] = x;
		shakeCenter[Y] = y;
	}

	// Finally, after moving the camera to its next position for the frame, offset its position relative to 
	// the current strength of the camera shake if one exists.
	if (shakeMagnitude > 0){
		x = shakeCenter[X] - irandom_range(-shakeMagnitude, shakeMagnitude);
		y = shakeCenter[Y] - irandom_range(-shakeMagnitude, shakeMagnitude);
		shakeMagnitude -= (shakeStrength / shakeLength) * global.deltaTime;
	}

	// After moving the camera to a new postiion; update the view matrix
	camera_set_view_mat(cameraID, matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0));
}