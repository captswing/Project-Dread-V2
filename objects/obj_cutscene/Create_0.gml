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

// Store the current states and previous states for each dynamic entity that existed during the start of 
// the cutscene. These state values will be restored once the cutscene concludes. Also, all dynamic entities
// will have their state set to "NO_STATE" during a cutscene.
prevEntityStates = -1;
var _index, _grid;
_index = 0;
_grid = ds_grid_create(2, instance_number(par_dynamic_entity));
with(par_dynamic_entity){
	_grid[# 0, _index] = id;
	_grid[# 1, _index] = [curState, lastState];
	set_cur_state(NO_STATE);
	_index++;
}
// Place the pointer to the grid in the variable that will also handle its deletion process.
prevEntityStates = _grid;

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

// A map and list that are used for handling objects created for the cutscene and only the cutscene. The list
// exists alongside the map in order to speed up the search when checking for instances that currently exist
// in the cutscene object map.
cutsceneObjects = ds_map_create();
objectsInMap = ds_list_create();

// A timer used during the cutscene_wait action, or for whenever else a simple timer is needed.
timer = 0;

#endregion

#region SETTING GAME STATE AND LOCKING PLAYER MOVEMENT

set_game_state(GameState.Cutscene, true); // Always prioritize the cutscene's state
with(global.singletonID[? PLAYER]) {entity_set_sprite(standSprite, 4);}

#endregion