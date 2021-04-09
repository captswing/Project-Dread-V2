/// @description Variable Initialization

// Add the object as a singleton to prevent duplicates. If it fails, exit the create event early.
if (!add_singleton_object()) {return;}

#region EDITING INHERITED VARIABLES

image_index = 0;
image_alpha = 0;
image_speed = 0;
visible = true;

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

// 
visibleText = "";
nextCharacter = 0;
finalCharacter = 0;

// 
textboxSoundID = noone;
textboxSoundTimer = 0;
textboxSoundSpeed = 4.25;

// 
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

#endregion

#region ADJUST THE CURRENT GAME STATE AND PAUSE THE PLAYER

set_game_state(GameState.InMenu, false);
with(global.singletonID[? PLAYER]) {set_sprite(standSprite, 4);}

#endregion