/// @description Handles collision between a dynamic entity and the world's collider objects. In a basic sense,
/// all the function will do is move the entity pixel-by-pixel until a wall is reached relative to either the
/// x-axis or y-axis. Optionally, the entity can be destroyed upon a collision occurring.
/// @param destroyOnCollide
function entity_world_collision(_destroyOnCollide){
	var _collision, _colliderID;
	_collision = false;
	_colliderID = noone;
	
	// Handling horizontal collision
	var _hspd = sign(hspd);
	if (place_meeting(x + deltaHspd, y, par_collider)){
		_collision = true;
		// Move pixel-by-pixel until the collider is reached.
		while(!place_meeting(x + _hspd, y, par_collider)){
			x += _hspd;
		}
		isDestroyed = _destroyOnCollide;
		deltaHspd = 0;
		hspd = 0;
	}
	x += deltaHspd;
	
	// Handling vertical collision
	var _vspd = sign(vspd);
	if (place_meeting(x, y + deltaVspd + zOffset, par_collider)){
		_collision = true;
		// Move pixel-by-pixel until the collider is reached.
		while(!place_meeting(x, y + _vspd + zOffset, par_collider)){
			y += _vspd;
		}
		isDestroyed = _destroyOnCollide;
		deltaVspd = 0;
		vspd = 0;
	}
	y += deltaVspd;
	
	// Return the ID of the collider for optional use outside of this function if a collision actually happened.
	if (_collision) {_colliderID = instance_place(x, y + zOffset, par_collider);}
	return _colliderID;
}