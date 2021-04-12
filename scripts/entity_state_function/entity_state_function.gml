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