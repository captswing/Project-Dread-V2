/// @description Handle Collision with World on Active Frames

// If no valid script was provided to the attack state; delete it
if (curState == NO_SCRIPT){
	instance_destroy(self, false);
	return;
}

// Call the parent step event code, which handles state code
event_inherited();