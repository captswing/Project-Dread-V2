/// @description Variable Initialization

#region SINGLETON CHECK

if (global.cutsceneID != noone){
	if (global.cutsceneID.object_index == object_index){
		instance_destroy(self);
		return;
	}
	instance_destroy(global.cutsceneID);
}
global.cutsceneID = id;

#endregion

#region EDITING INHERITED VARIABLES

image_index = 0;
image_speed = 0;
visible = false;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Store what the current game state was at the cutscene's creation, which will overwrite any game state
// changes during the cutscene if they somehow occur.
prevGameState = global.gameState;

// A queue containing all the instructions that need to be executed for a given cutscene. The object will
// remain active and executing these instructions until the queue in emptied. The player should not be able
// to move during the scene.
sceneData = ds_queue_create();

// 
timer = 0;

//
directionSet = false;

#endregion

#region SETTING GAME STATE AND LOCKING PLAYER MOVEMENT

set_game_state(GameState.Cutscene, true); // Always prioritize the cutscene's state
with(global.playerID) {set_sprite(standSprite, 4);}

#endregion