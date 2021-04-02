/// @description Removes the textbox data from the 0th position of the list. If no more textbox data exists
/// in the data list, the textbox handler object will be deleted. Also resets the typewriter effect variables.
function open_next_textbox(){
	ds_list_delete(textboxData, 0);
	// No more data remains in the struct list; delete the entire object
	if (ds_list_size(textboxData) == 0) {instance_destroy(self);}
	// If more textboxes still remain in the list, reset variables for the next textbox
	nextCharacter = 0;
	visibleText = "";
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
	//			textboxSprite		--		sprite_index
	//			namespaceSprite		--		sprite_index
	//			textboxColor		--		color
	//			portraitSprite		--		sprite_index
	//			firstName			--		string
	//			lastName			--		string
	//
	
	// Go through the list of possible actor indexes to find the one taht needs to be returned
	switch(_actor){
		case Actor.Claire: // The main character's actor data
			_data = {
				textboxSprite : spr_textbox0,
				namespaceSprite : spr_textbox0_namespace,
				textboxColor : make_color_rgb(110, 0, 204),
				portraitSprite : -1,
				firstName : "Claire",
				lastName : "Foster"
			}
			break;
		default: // The default actor data (Usually no actor)
			_data = { // NOTE -- Only the background sprite, its color, and firstName variable needs to exist
				textboxSprite : spr_textbox0,
				textboxColor : make_color_rgb(0, 0, 188),
				firstName : "NoActor"
			}
			break;
	}
	
	// Finaly, either return the struct data or a -4, which signifies no struct was successfully created
	return _data;
}