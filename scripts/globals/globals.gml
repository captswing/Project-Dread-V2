/// @description Initializes all global variables with default values.

//file_fast_crypt_ultra_zlib("item_data.json", "item_data.json", true, "5v8x/A?D(G+KbPeShVmYq3t6w9z$B&E)H@McQfTjWnZr4u7x!A%D*G-JaNdRgUkX");
//file_fast_crypt_ultra_zlib("world_item_data.json", "world_item_data.json", true, "fTjWnZr4u7x!z%C*F-JaNdRgUkXp2s5v8y/B?D(G+KbPeShVmYq3t6w9z$C&F)H@");
//file_fast_crypt_ultra_zlib("dialogue_data.json", "dialogue_data.json", true, "@NcRfUjWnZr47x!A%D*G-KaPdSgVkYp2s5v8y/B?E(H+MbQeThWmZq4t6w9z$C&F");

// Loads in the game's item data from the json data file. It includes everything involving an item and what 
// it is able to do -- within reason. From the item's description, to its icon on the inventory screen. From
// the damage modifier it places on a specific gun, to its effects when consumed by the player.
global.itemData = encrypted_json_load("item_data", "5v8x/A?D(G+KbPeShVmYq3t6w9z$B&E)H@McQfTjWnZr4u7x!A%D*G-JaNdRgUkX");

// This map stores all of the current items that exist within the world. This also includes any items dropped
// by the player, since those don't disappear and are instead left exactly where the player left them. It works
// exactly how the items in Resident Evil: Zero function; turning the world into one big storage container.
//
//		The data is stored as such:
//				Key		=	item's ID number
//				Value	=	{name, quantity, durability, x, y, room}
//					NOTE -- The only items that contain an x and y position, plus a room index are
//							items that have been dropped onto the ground by the player.
//
global.worldItemData = encrypted_json_load("world_item_data", "fTjWnZr4u7x!z%C*F-JaNdRgUkXp2s5v8y/B?D(G+KbPeShVmYq3t6w9z$C&F)H@");
// TODO -- Move this to when the "New Game" is selected, since loading from a save file will use the world item data map from that file's data

// 
global.dialogueData = encrypted_json_load("dialogue_data", "@NcRfUjWnZr47x!A%D*G-KaPdSgVkYp2s5v8y/B?E(H+MbQeThWmZq4t6w9z$C&F");

// A map that stores all the texture data for the game's available fonts. The key is the number given to the 
// font given by GML itself, which is a constant given by referencing the font resource itself.
global.fontTextures = ds_map_create();
// Since these key/value pairs aren't ever changed or updated, they should all be set below.
ds_map_add(global.fontTextures, font_gui_small,		font_get_texture(font_gui_small));
ds_map_add(global.fontTextures, font_gui_medium,	font_get_texture(font_gui_medium));
ds_map_add(global.fontTextures, font_gui_large,		font_get_texture(font_gui_large));

// Singleton variables that keep track of important instances; preventing them from being created multiple times
// which would cause a myriad of issues, if the game even ran at all with multiple instances of these objects.
global.controllerID = noone;		// For obj_controller
global.effectID = noone;			// For obj_shader_handler
global.sorterID = noone;			// For obj_depth_sorter
global.playerID = noone;			// For obj_player
global.textboxID = noone;			// For obj_textbox_handler

// Holds the game's current state. This state determines the functionality of certain objects.
global.gameState = GameState.InGame;

// Two variables that allow for the use of a variable frame rate. The first tracks the difference in time between 
// the frames relative to the target FPS, and the second determines the game's target FPS for one second of real 
// time. This value determines where delta time will equal to a value of 1.00.
global.deltaTime = 0;
global.targetFPS = 60;

// A grid with the dimensions 2 by n, where n is equal to the total number of world object that exist currently
// for drawing using the depth sorting system. The grid is sorted by the current Y values of each object every
// frame.
global.worldObjects = ds_grid_create(2, 0);

// An array that stores the player's individual settings for things like resolution, fullscreen, frame rate limit,
// vertical syncronization, keybindings, accessibility settings, and so on. These will be given a default value
// if no "settings.ini" file can be found on the user's PC, and if the file exists, the values from there will
// be loaded into the array.
global.settings = array_create(Settings.Length, 0);

// Stores the ID slot that the gamepad is currently connected to relative to Microsoft's XIpnut/DirectInput systems.
// Also, a flag exists that either enables or disables keyboard controls relative to the last input that was detected
// from either a gamepad or keyboard.
global.gamepadID = -1;
global.gamepadActive = false;

// A boolean that determines if the player is currently in a room that is considered safe or not. It only affects
// how the player's sanity modifier will set to as a standard value -- a value of one for when the room is considered
// "safe" and it will be a value of negative one if the room is considered "unsafe." Objects placed in the room will
// determine what the standard sanity value is for that given room.
global.isRoomSafe = false;

// Tracks the total in-game play time for the current save game's file. It's a single variable that is converted
// to a HH:MM:SS format whenever it needs to be displayed to the user. The time is only tracked when outside of
// certain menus, like the settings, statistics, bonuses, load game, and whenever a message or confirmation prompt 
// pops up for the user. The flag below controls when the timer is active or not.
global.totalPlaytime = 0;
global.freezeTimer = false;

// A variable that stores the converted value for the player's current in-game play time. This allows for displaying
// the time in the correct format without having to constantly convert it whenever its needed.
global.playtimeString = "00:00:00";

// These variables are somewhat redundant data, but they are required in order to allow for seamless transitioning
// of background music within the game. The first variable holds the index given by game maker for the song itself,
// and the second variable tracks how long the song's loop is.
global.curSong = -1;
global.loopLength = -1;

// The two main variables for handling the player's currently held items. The first variable (inventorySize) stores
// the current accessible space within the item inventory. This variable can be increased by finding inventory upgrades
// throughout available throughout the game. The final total space is different for almost all difficulty levels.
//
//		MAX INVENTORY SIZES:		STARTING SIZE:		MAXIMUM SIZE:
//				Forgiving		--		12 slots			24 slots	(6 Upgrades)
//				Standard		--		8  slots			20 slots	(6 Upgrades)
//				Punishing		--		8  slots			16 slots	(4 Upgrades)
//				Nightmare		--		6  slots			12 slots	(3 Upgrades)
//				One Life Mode	--		6  slots			10 slots	(2 Upgrades)
//
global.invSize = 0;
for (var i = 0; i < MAX_INV_SIZE; i++){
	global.invItem[i][0] = NO_ITEM;	// The item's key within the item data map
	global.invItem[i][1] = 0;		// Total number of items currently in the slot
	global.invItem[i][2] = 0;		// The item's durability (Nightmare and One Life Mode only)
	global.invItem[i][3] = false;	// A flag storing if the item is equipped to the player or not
}

// The main variable for keeping track of the player's currently found notes and important documents. The size of this
// section of the inventory isn't limited, and a theoretical infinite amount of notes/memos/documents can be stored
// at one time. All it stores is a string value for the name of the note, which will allow easy reference to the 
// information found within the note.
global.invNote = ds_list_create();

// Two variables that keep track of the game's current combat/gameplay difficulty and puzzle difficulty. If
// either are still set to NotSelected when the game starts up, they will be changed to their respective 
// standard difficulty levels. The values stored in these variables are saved in a per-savefile basis.
global.gameplayDiff = Difficulty.NotSelected;
global.puzzleDiff = PuzzleDifficulty.NotSelected;