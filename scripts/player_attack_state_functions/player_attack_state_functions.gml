// @description
function player_attack_state_projectile(){
	// Check if the projectile has exceeded its maximum range. If it has, the bullet will be destroyed
	if (point_distance(startX, startY, x, y) >= range){
		isDestroyed = true;
		return; // Exit out of the script early
	}
	
	// TODO -- Add hostile projectile check here
	
	// First, remove fractions from the movement variables to prevent sub-pixel movement
	remove_movement_fractions();
	// Collision check -- The entity is moving too quick to deal with pixel perfect collision, use
	// collision_line instead to check if a collision did happen. Also takes into account the height
	// of the object, so shorter objects will not be collided with.
	var _collider = collision_line(x, y, x + deltaHspd, y + deltaVspd, par_collider, false, true);
	if (_collider != noone && (_collider.colliderHeight == -1 || _collider.colliderHeight > zOffset)){ // A collision occurred; destroy the object
		isDestroyed = true;
		return; // Exit out of the script early
	}
	// No collision, just move the projectile
	x += deltaHspd;
	y += deltaVspd;
}