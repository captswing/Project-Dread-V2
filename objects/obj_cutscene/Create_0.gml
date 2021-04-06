/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

image_index = 0;
image_speed = 0;
visible = false;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// A queue containing all the instructions that need to be executed for a given cutscene. The object will
// remain active and executing these instructions until the queue in emptied. The player should not be able
// to move during the scene.
sceneData = ds_queue_create();

// 
timer = 0;

//
directionSet = false;

#endregion

#region SET GAME STATE AND FREEZE PLAYER INPUT

global.gameState = GameState.InMenu;
with(global.playerID) {set_sprite(standSprite, 4);}

#endregion