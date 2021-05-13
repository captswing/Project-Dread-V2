/// @description Draw Arrow Pointing In Direction of Warp

// If the player can't even interact with the object, don't bother checking for their interaction point. Another
// prevention is if the indicator index hasn't been set at all, which can be used for hidden warps and the like.
if (!canInteract || indicatorIndex == -1) {return;}

// Attempt to retrieve the player's indicator point position, which is a position that is a radius of 8 pixels
// away from the player's actual position -- offset upward by 4 pixels. It the player object doesn't exist for
// some reason, the value will remain at (-128, -128). The faroff negative will prevent the interact radius 
// from ever being triggered as true.
var _playerPos = [-128, -128];
with(global.singletonID[? PLAYER]){
	_playerPos = [x, y];
}

// Checks if the point is located within the interaction radius, and if so the indicator sprite will be drawn;
// the index of which is determined in the creation code of the warp itself.
if (point_distance(interactCenter[X], interactCenter[Y], _playerPos[X], _playerPos[Y]) <= global.settings[Settings.DoorIndicatorRange]){
	var _offset = [0, 0];
	switch(indicatorIndex){ // Each incorporates the offset that makes it animate
		case INDEX_EAST:	_offset = [12 + floor(indicatorOffset), 4];		break;
		case INDEX_NORTH:	_offset = [0, -12 - floor(indicatorOffset)];	break;
		case INDEX_WEST:	_offset = [-12 - floor(indicatorOffset), 4];	break;
		case INDEX_SOUTH:	_offset = [0, 12 + floor(indicatorOffset)];		break;
	}
	// Store the positions on screen to darw the indicator at in variables so everything is cleaner
	var _xPos = interactCenter[X] + _offset[X] - camera_get_x();
	var _yPos = interactCenter[Y] + _offset[Y] - camera_get_y();
	draw_sprite(spr_warp_indicator, indicatorIndex, _xPos, _yPos);
}

// Finally, update the offset for the indicator using its speed variables against delta time.
indicatorOffset += indicatorSpeed * global.deltaTime;
if (indicatorOffset >= 2) {indicatorOffset = 0;}