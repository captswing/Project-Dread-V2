/// @description A simple state shared by all entities that will stun them for an alloted span of time. This
/// allows enemies to be stun locked by the player if the damage dealt to them was high enough. Otherwise,
/// it's a chance that the enemy will be stunned.
function state_entity_stun_locked(){
	stunLockTimer -= global.deltaTime;
	if (stunLockTimer < 0){ // The stun lock has completed, release the entity and let it animate
		set_cur_state(lastState);
		animateSprite = true;
	}
}

/// @description A state shared by all entities that allows them to move to a target position relative to their
/// maximum speed. The state will be set to whatever the previous state was after the target position is reached.
/// It's important to note that this state is primarily used during cutscenes; to allow multiple entities to
/// move at once during a cutscene if necessary.
function state_entity_move_to_position(){
	// Sets the direction once at the start of the entity movement, which prevent weird spinning issues
	// that can occur when the direction is updated on a frame-by-frame basis.
	if (!directionSet){
		direction = point_direction(0, 0, sign(targetPosition[X] - x), sign(targetPosition[Y] - y));
		directionSet = true;
	}
	// Set the entity's movement based on their current maximum movement speed, relative to the
	// direction they have to move toward in order to reach their destination.
	var _dir = point_direction(x, y, targetPosition[X], targetPosition[Y]);
	hspd = lengthdir_x(maxHspd, _dir);
	vspd = lengthdir_y(maxVspd, _dir);
	// After calculating the movement speed, remove fractional values and apply delta time.
	remove_movement_fractions();
	
	// The entity has reached its destinations, lock them onto the desination position and end the action
	if (point_distance(0, 0, deltaHspd, deltaHspd) > point_distance(x, y, targetPosition[X], targetPosition[Y])){
		entity_set_sprite(standSprite, 4);
		set_cur_state(lastState);
		x = floor(targetPosition[X]);
		y = floor(targetPosition[Y]);
		directionSet = false; // Reset the set direction flag
	} else{ // Entity has not reached their destination; move them and set to moving sprite
		entity_set_sprite(walkSprite, 4);
		x += deltaHspd;
		y += deltaVspd;
	}
}