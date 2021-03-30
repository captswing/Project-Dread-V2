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
					show_debug_message("COLLISION");
					i = _length; // Exits the loop
				}
				break;
		}
	}
	// Finally, remove the ds_list from memory; preventing any memory leaks
	ds_list_destroy(_collisions);
}