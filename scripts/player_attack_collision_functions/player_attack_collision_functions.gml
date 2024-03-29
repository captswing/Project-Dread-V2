/// @description Handles collision between the player's attack and whatever objects it can interact with. An
/// important note is that the height offset for the object that gives it a true 2.5D effect is factored in
/// during this function, and doesn't need to be applied by the programmer.
/// @param startX
/// @param startY
/// @param endX
/// @param endY
function player_attack_hitscan_collision(_startX, _startY, _endX, _endY, _zOffset){
	// Create a temporary ds_list to store all the collisions that occur along the scan
	var _collisions = ds_list_create();
	collision_line_list(_startX, _startY - _zOffset, _endX, _endY - _zOffset, all, false, true, _collisions, true);
	// Loops through the list of objects found in the collision check, and handles collisions until
	// the attack object is deleted by one of the collisions OR no valid collision occurred.
	var _length = ds_list_size(_collisions);
	for (var i = 0; i < _length; i++){
		var _objIndex = _collisions[| i].object_index;
		switch(object_get_parent(_objIndex)){
			case par_collider: // Colliding with a wall or a tall enough object
				if (_collisions[| i].colliderHeight == -1 || colliderHeight > zOffset){
					i = _length; // Exits the loop
				}
				break;
			case par_enemy: // Colliding with an enemy object
				player_attack_enemy_collision(_collisions[| i], player_get_weapon_damage());
				i = _length; // Always exits the loop after resolving collision
				break;
		}
	}
	// FOR DEBUGGING HITSCAN STUFF
	var _debug = instance_create_depth(_startX, _startY - _zOffset, GLOBAL_DEPTH, obj_debug_line);
	with(_debug){
		endX = _endX;
		endY = _endY - _zOffset;
	}
	// Finally, remove the ds_list from memory; preventing any memory leaks
	ds_list_destroy(_collisions);
}

/// @description Handles collision with by a player's projectile/melee attack with an enemy object. Checks if 
/// the attack should cause a stunlock to the player relative to the damage that the attack dealt. If the 
/// damage is less than the threshold value, the stun will be calculated by the percent chance of stun out of 
/// 100% (Stored as a value between 0 and 1).
/// @param enemyID
/// @param damage
function player_attack_enemy_collision(_enemyID, _damage){
	with(_enemyID){ // After calculating the player's damage, deal it to the enemy and check if stun locked
		if (_damage >= stunLockThreshold || random(1) <= stunLockChance){ // The enemy was stunned
			entity_set_hit(_damage, stunLockTime);
		} else{ // No stun has occurred, just deal out the damage
			entity_set_hit(_damage, 0);
		}
	}
}