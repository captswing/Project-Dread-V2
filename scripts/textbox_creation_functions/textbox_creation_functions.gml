/// @description Creates a simple textbox with no actor or actor portrait, just some text. The color of the
/// textbox is determined from a barebones actor, however, which is named NoActor. All textboxes created by
/// this command will share that actor.
/// @param text
function create_textbox(_text){
	// Simply calls the full-fledged textbox creation function, but with the actor and image index hardcoded
	create_textbox_actor_portrait("> " + _text, Actor.None, -1);
}

/// @description Creates a textbox with text and an actor associated with it, but the actor does not use
/// a portrait, so it is disabled for the textbox. This is useful for named characters that aren't integral
/// to the game's plot, but are named nonetheless.
/// @param text
/// @param actor
function create_textbox_actor(_text, _actor){
	// Simply calls the full-fledged textbox creation function, but with the image index as a hardcoded value
	create_textbox_actor_portrait(_text, _actor, -1);
}

/// @description Creates a fully-utilized textbox with text, an actor, and the portrait's image index provided.
/// The image index allows different faces to be shown on individual textboxes; allowing for greater expression
/// of the characters during cutscenes. This function is mostly reserved for the major characters in the game.
/// @param text
/// @param actor
/// @param imageIndex
function create_textbox_actor_portrait(_text, _actor, _imageIndex){
	// If the single textbox variable doesn't have an ID associated with in, create the textbox handler object
	if (global.singletonID[? TEXTBOX] == noone){
		instance_create_depth(0, WINDOW_HEIGHT + 10, GLOBAL_DEPTH, obj_textbox);
	}
	// Jump into the textbox handler and add the data to its textbox list and actor map
	with(global.singletonID[? TEXTBOX]){
		if (_imageIndex >= 0){ // Only offset the text if a value imageIndex value was passed in
			add_textbox_data(string_split_lines(_text, WINDOW_WIDTH - 92, font_gui_small), _actor, _imageIndex);
		} else{ // If no valid imageindex was provided, offset the text as normal (40 pixels)
			add_textbox_data(string_split_lines(_text, WINDOW_WIDTH - 40, font_gui_small), _actor, _imageIndex);
		}
		// Finally, attempt to add the actor's date to the actor map
		add_actor_data(_actor);
	}
}

/// @description Creates a decision that will occur in the textbox when it reaches the given index. It stores
/// all possible decisions and their respective outcomes into a map of decision data. The key for this map
/// value is the index that the decisions occur at.
/// @param index
/// @param decisions
/// @param outcomes
function create_textbox_decision(_index, _decisions, _outcomes){
	with(global.singletonID[? TEXTBOX]){ // Only set decisions and outcomes at an index that doesn't exist yet
		if (is_undefined(ds_map_find_value(decisionData, _index))){
			ds_map_add(decisionData, _index, [_decisions, _outcomes]);
		}
	}
}