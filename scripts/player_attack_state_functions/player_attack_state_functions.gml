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
	// collision_line instead to check if a collision did happen.
	if (collision_line(x, y, x + deltaHspd, y + deltaVspd, par_collider, false, true)){ // A collision occurred; destroy the object
		isDestroyed = true;
		return; // Exit out of the script early
	}
	// No collision, just move the projectile
	x += deltaHspd;
	y += deltaVspd;
}