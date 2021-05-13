/// @description Variable Initialization

// Add the object as a singleton to prevent duplicates. If it fails, exit the create event early.
if (!add_singleton_object()) {return;}

#region EDITING INHERITED VARIABLES

image_index = 0;
image_alpha = 0;
image_speed = 0;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Keyboard input variables
keyAdvance = false;
// TODO -- Add a potential log of textboxes here

// Holds the index for the shader used for outlining the text
outlineShader = shd_outline;
// Getting the uniforms for the shader; storing them in local variables
sPixelWidth = shader_get_uniform(outlineShader, "pixelWidth");
sPixelHeight = shader_get_uniform(outlineShader, "pixelHeight");
sOutlineColor = shader_get_uniform(outlineShader, "outlineColor");
sDrawOutline = shader_get_uniform(outlineShader, "drawOutline");

// 
isClosing = false;
yTarget = WINDOW_HEIGHT - 57;
alpha = 0;

// The variables that are responsible for the "typewriter" text effect that the textboxes have. They store the
// current text that is visible to the player, the next character that is going to be added to that visible text,
// and the final character in the string, which signifies to the effect that it no longer needs to add characters.
visibleText = "";
nextCharacter = 0;
finalCharacter = 0;

// 
textboxSoundID = noone;
textboxSoundTimer = 0;
textboxSoundSpeed = 4.25;

// Stores the offset of the textbox's advance indicator, which shows up once all of the text contained in
// the current textbox is visible to the screen. The speed determines how fast the offset value shifts between
// 0 and 1, which makes the indicator have a simple bouncing animation.
indicatorOffset = 0;
indicatorSpeed = 0.06;

// A list of indefinite length that store data about a given piece of dialogue within the queue. (The 0th 
// index is the only visible textbox at any given time) Basically, it stores the speaker's name and the text
// that they are supposed to be saying.
textboxData = ds_list_create();
// The data for the textbox data is stored as follows:
//
//			0	--	actual dialogue
//			1	--	actor's ID value
//			2	--	portrait image index
//

// Two important variables for the textbox system to function properly. The first variable stores the index 
// for the current textbox data that is being displayed to the user. This allows for jumping to previous 
// points in the textbox without any issue. The second variable stores the last code that was passed into
// the object. A value of "end" overrides any other code and will cause the textbox to close after the
// current textbox has been advanced.
textboxIndex = 0;
textboxCode = "";

// 
decisionData = ds_map_create();

// A map of data relating to the actors that have textboxes associated with them. It contains data about the
// background color of the textbox, the color of their name, (Both inner color and outline color) the sprite
// index for their character portrait, and their first and last names -- split into separate variables. The
// only exception to this is when no actor is associated with the textbox; in which case the first name
// is always "NoActor" and the color of the background is also set -- no other variables exist in the struct.
actorData = ds_map_create();
//
// NOTE --  Each index of this map contains a struct containing data about that piece of dialogue. DO NOT
//			FORGET TO CLEAR THAT SHIT FROM MEMORY BEFORE DELETING THE LIST OTHERWISE A MEMORY LEAK IS GONNA
//			HAPPEN AND IT'S GONNA HAPPEN BAAAAAAAAAAAAD!!!
//

// Responsible for storing the player's current and last state for the duration of the textbox's existence.
// Once the textbox is closed, the states will be returned back to the player object.
prevPlayerState = 0;

#endregion

#region PAUSE THE PLAYER

// Only pause the player's input and store their state if a cutscene isn't currently occurring.
if (global.gameState == GameState.InGame){
	var _state = 0; // Get the player's current and previous states; storing them in an array.
	with(global.singletonID[? PLAYER]){
		_state = [curState, lastState];
		entity_set_sprite(standSprite, 4);
		set_cur_state(NO_SCRIPT);
	}
	prevPlayerState = _state;
}

#endregion