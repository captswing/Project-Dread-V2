/// @description Variable Initialization

// Add the object as a singleton to prevent duplicates. If it fails, exit the create event early.
if (!add_singleton_object()) {return;}

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

// Stores the index for the current script in a seperate variable in order to use it in the script_execute_ext
// to properly work.
sceneScript = NO_SCRIPT;

// Holds the ID for the cutscene trigger that created this object. Once the cutscene has been successfully
// executed, the trigger will delete itself relative to this object's clean up event.
parentTrigger = noone;

// A timer used during the cutscene_wait action, or for whenever else a simple timer is needed.
timer = 0;

// A flag for determining the direction an entity should be facing when they begin moving during any action
// that causes movement to a child of par_dynamic_entity.
directionSet = false;

#endregion

#region SETTING GAME STATE AND LOCKING PLAYER MOVEMENT

set_game_state(GameState.Cutscene, true); // Always prioritize the cutscene's state
with(global.singletonID[? PLAYER]) {set_sprite(standSprite, 4);}

#endregion