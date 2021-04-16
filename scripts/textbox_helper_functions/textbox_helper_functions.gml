/// @description Adds textbox data to the end of the ds_list of said data. The text MUST be formatted during
/// or before passing it into this function because no formatting occurs within the function.
/// @param text
/// @param actor
/// @param imageIndex
function add_textbox_data(_text, _actor, _imageIndex){
	ds_list_add(textboxData, [_text, _actor, _imageIndex]);
	if (ds_list_size(textboxData) == 1) {finalCharacter = string_length(textboxData[| 0][0]);}
}

/// @description Removes the textbox data from the 0th position of the list. If no more textbox data exists
/// in the data list, the textbox handler object will be deleted. Also resets the typewriter effect variables.
function open_next_textbox(){
	ds_list_delete(textboxData, 0);
	// No more data remains in the struct list; delete the entire object
	if (ds_list_size(textboxData) == 0){
		instance_destroy(self);
		return;
	}
	// If more textboxes still remain in the list, reset variables for the next textbox
	finalCharacter = string_length(textboxData[| 0][0]);
	nextCharacter = 0;
	visibleText = "";
	textboxSoundTimer = 0;
}

/// @description Attempts to add an actor's data to the map of actors for the current textboxes. However, if
/// the actor's data already exists within the map, no actor data will be searched for or added and this
/// function will essentially do nothing.
/// @param actor
function add_actor_data(_actor){
	var _existingActor = ds_map_find_value(actorData, _actor);
	if (is_undefined(_existingActor)){ // Only add new data to the map if is a new actor struct
		var _newActor = get_actor_data(_actor);
		ds_map_add(actorData, _actor, _newActor);
	}
}

/// @description Fetches the struct containing data about the actor based on the index provided. The struct
/// contains data about the textbox sprite that's used, the namespace's sprite, the color of both of those
/// textboxes, the portrait sprite index for the actor, and their first and last names.
/// @param actor
function get_actor_data(_actor){
	// This variable will either store the value noone (-4) or a pointer to the struct created by the
	// name provided in the function's argument value.
	var _data = noone;
	// The variables that can exist within the _data struct include:
	//
	//			firstName			--		string
	//			textboxColor		--		color
	//			textboxSprite		--		sprite_index
	//			namespaceSprite		--		sprite_index
	//			portraitSprite		--		sprite_index
	//
	
	// Go through the list of possible actor indexes to find the one taht needs to be returned
	switch(_actor){
		case Actor.Claire: // The main character's actor data
			_data = {
				firstName : "Claire",
				textboxColor : make_color_rgb(110, 0, 204),
				textboxSprite : spr_textbox0,
				namespaceSprite : spr_textbox0_namespace,
				portraitSprite : spr_claire_portraits
			}
			break;
		default: // The default actor data (No specified actor)
			_data = { // NOTE -- Only the name, background color and sprite variables need to exist
				firstName : "NoActor",
				textboxColor : make_color_rgb(0, 0, 188),
				textboxSprite : spr_textbox0,
			}
			break;
	}
	
	// Finaly, either return the struct data or a -4, which signifies no struct was successfully created
	return _data;
}