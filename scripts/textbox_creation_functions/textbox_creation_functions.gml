/// @description Creates a textbox and the textbox object that handles the data contained within the textbox
/// content -- the text itself and the actor/character associated with the textbox, which determines a few
/// elements of the textbox itself. If textboxes are queued up within obj_textbox already, this function will
/// simply add the data to the list of textbox data found within the handler object.
/// @param text
/// @param actor
function create_textbox(_text, _actor){
	// If no textbox object currently exists within the single variable, create said textbox.
	if (!instance_exists(global.textboxID)) {instance_create_depth(0, WINDOW_HEIGHT + 10, GLOBAL_DEPTH, obj_textbox);}
	// Add the textbox information to the list of data in the textbox object. Also, add the textbox's
	// associated actor to the map if they aren't currently in the map.
	with(global.textboxID){
		var _data = get_actor_data(_actor);
		ds_list_add(textboxData, [string_split_lines(_text, 280, font_gui_small), _data.firstName]);
		if (!is_undefined(ds_map_find_value(actorData, _data.firstName))){
			delete _data; // Remove the duplicate struct from memory
			_data = noone;
		}
		// If the struct wasn't a duplicate, add the data to the actor map. Optionally, calculate the
		// width of the namespace if the actor's name shows up there.
		if (_data != noone){
			ds_map_add(actorData, _data.firstName, _data);
			if (_data.firstName != "NoActor"){
				draw_set_font(font_gui_small); // Change the active drawing font for accurate calculation
				namespaceWidth = string_width(_data.firstName) + 14;
			}
		}
	}
}