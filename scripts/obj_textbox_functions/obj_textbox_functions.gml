/// @description Creates a textbox handler containing the data for whatever starting key was provided into
/// the function. It will continue to parse in dialogue data until an undefined value is found OR a key
/// with the value of "END" has been hit. Then, the handler will begin its process.
/// @param dialogueKey
function create_dialogue(_dialogueKey){
	// Don't attempt to create another dialogue handler if one exists currently
	if (global.textboxID != noone){
		return;
	}
	// Create the manager object that will handle the supplied dialogue
	var _textbox = instance_create_depth(0, WINDOW_HEIGHT + 10, GLOBAL_DEPTH, obj_textbox_handler);
	with(_textbox){
		// Attempt to loop through all the needed dialogue until an undefined value has been found; exiting after that
		var _mapData = ds_map_find_value(global.dialogueData[? DIALOGUE_DATA], _dialogueKey);
		while(!is_undefined(_mapData)){
			// Parse out all of the "pages" of dialogue that are contained within the current textbox
			var _length, _dialogue;
			_length = ds_list_size(_mapData[? DIALOGUE]);
			_dialogue = array_create(0, "");
			for (var i = 0; i < _length; i++){
				_dialogue[i] = string_split_lines(_mapData[? DIALOGUE][| i], WINDOW_WIDTH - 40, font_gui_small);
			}
		
			// After parsing the dialogue into pages, create the textbox and fetch the colors relative to
			// the actor that is connected to the textbox's contents
			var _textbox, _actor;
			_textbox = new Textbox(_mapData[? ACTOR], _dialogue);
			_actor = global.dialogueData[? ACTOR_DATA][? _mapData[? ACTOR]];
			with(_textbox){ // Setting the colors and portrait based on the actor speaking
				backColor =	make_color_rgb(_actor[? BACK_COLOR][| 0], _actor[? BACK_COLOR][| 1], _actor[? BACK_COLOR][| 2]);
				// Name and portrait data doesn't need to be added when the actor is "NoActor"
				if (_mapData[? ACTOR] != NO_ACTOR){
					nameColor =	make_color_rgb(_actor[? NAME_COLOR][| 0], _actor[? NAME_COLOR][| 1], _actor[? NAME_COLOR][| 2]);
					nameOutlineColor = [_actor[? NAME_COLOR][| 3] / 255, _actor[? NAME_COLOR][| 4] / 255, _actor[? NAME_COLOR][| 5] / 255];
					// TODO -- Set portrait ID here
				}
			}
			
			// Finally, place the data into the textbox queue and move onto the next dialogue if the ID is valid
			ds_queue_enqueue(textboxes, _textbox);
			_mapData = ds_map_find_value(global.dialogueData[? DIALOGUE_DATA], _mapData[? NEXT_ID]);
		}
	}
}

/// @description The "lightweight" object that holds data for a textbox within the game. These textboxes work
/// by holding a speakers name, and an array of strings that will be shown on the textbox. After this array
/// of dialogue strings has been accessed, the textbox will tell the handler to close itself and see if
/// another textbox will be opened or the handler will be deleted.
/// @param speaker
/// @param dialogue
/// @param transitionAfter
function Textbox(_speaker, _dialogue) constructor{
	// The three main variables that allow the textbox to actually function as its supposed to. The first
	// variable is the name of the actor speaking the dialogue (Acts as the name AND the key for additional 
	// data) and an array of dialogue the actor will speak; followed by the current array index of dialogue
	// being shown to the player.
	speaker = _speaker;
	dialogue = _dialogue;
	dialogueIndex = 0;
	
	// Variables that are determined by what actor is speaking currently. The name's inside and outline
	// color can be changed, and the background of the textbox can also be altered for specific characters.
	nameColor = c_white;
	nameOutlineColor = [0.5, 0.5, 0.5];
	backColor = c_blue;
	
	// Holds the image index for the actor's portrait within the sprite
	portraitID = -1;
	
	// These two variables handle the typewriter scrolling effect that is based on the text speed 
	// accessibility setting. The visible dialogue is what is displayed while the full dialogue exists
	// in a hidden array.
	visibleDialogue = "";
	nextCharacter = 0;
	
	// A flag that tells obj_textbox_handler when to move onto the next chunk of textbox data within the
	// queue of data it has lined up. It destroys this instance from memory through said handler.
	isDestroyed = false;
	
	// Stores all the shader stuff in static variables to save on memory between instances
	static outlineShader = shd_outline;
	// Getting the uniforms for the shader; storing them in local, but static variables
	static sPixelWidth =	shader_get_uniform(outlineShader, "pixelWidth");
	static sPixelHeight =	shader_get_uniform(outlineShader, "pixelHeight");
	static sOutlineColor =	shader_get_uniform(outlineShader, "outlineColor");
	static sDrawOutline =	shader_get_uniform(outlineShader, "drawOutline");
	
	/// @description Handles textbox input and the scrolling typewriter-like text effect.
	static update_textbox = function(){
		// Checks whether or not the text has completely scrolled onto the textbox. If it has, the next
		// chunk of text will be moved to the 0th position of the queue and this textbox will be deleted.
		var _keyNext = keyboard_check_pressed(global.settings[Settings.Interact]);
		if (_keyNext){ // Auto-filling the textbox or moving to the next chunk of dialogue
			if (visibleDialogue == dialogue[dialogueIndex]){
				visibleDialogue = "";
				nextCharacter = 0;
				dialogueIndex++;
				if (dialogueIndex >= array_length(dialogue)){
					isDestroyed = true;
					return; // Exit out of the event early
				}
			} else if (nextCharacter > 3){
				nextCharacter = string_length(dialogue[dialogueIndex]);
			}
		}
		
		// These two lines create the typewriter scrolling effect for the textbox, relative to the text 
		// speed that was set in the accessibility menu by the user.
		nextCharacter += global.settings[Settings.TextSpeed] * global.deltaTime;
		visibleDialogue = string_copy(dialogue[dialogueIndex], 0, nextCharacter);
	}
	
	/// @description Handles drawing of the textbox and its currently visible text to the screen 
	/// at the function's provided coordinates.
	/// @param x
	/// @param y
	/// @param alpha
	static draw_textbox = function(_x, _y, _alpha){
		// Drawing the background for the textbox
		draw_sprite_general(spr_rectangle, 0, 1, 1, 1, 1, _x, _y + 1, WINDOW_WIDTH, 58, 0, backColor, backColor, c_black, c_black, 0.75 * _alpha);
		draw_sprite_ext(spr_rectangle, 0, _x, _y, WINDOW_WIDTH, 1, 0, c_black, _alpha); // Top border
		draw_sprite_ext(spr_rectangle, 0, _x, _y + 59, WINDOW_WIDTH, 1, 0, c_black, _alpha); // Bottom border
		
		// TODO -- Draw the portrait here
		
		// Set the alpha value for the text
		draw_set_alpha(_alpha);
		
		// Start the outline shader for the text contents of the textbox
		shader_set(outlineShader);
		shader_set_uniform_i(sDrawOutline, 1);
		
		// Drawing the name of the speaker with their unique name color (Only if the name isn't "NoActor"
		if (speaker != NO_ACTOR){
			draw_set_color(nameColor);
			shader_set_uniform_f_array(sOutlineColor, nameOutlineColor);
			outline_set_font(font_gui_medium, global.fontTextures[? font_gui_medium], sPixelWidth, sPixelHeight);
			draw_text(_x + 10, _y + 3, speaker);
		}
		
		// Drawing the visible portion of what the speaker is currently saying in white text with 
		// a gray outline surrounding it
		draw_set_color(c_white);
		shader_set_uniform_f_array(sOutlineColor, [0.5, 0.5, 0.5]);
		outline_set_font(font_gui_small, global.fontTextures[? font_gui_small], sPixelWidth, sPixelHeight);
		draw_text(_x + 20, _y + 16, visibleDialogue);
		
		shader_reset();
	}
}