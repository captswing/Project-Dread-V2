/// @description
/// @param sectionIndex
function inventory_initialize_section(_sectionIndex){
	// Clearing out all of the previous data from the menu if it exists during this function call
	if (numOptions > 0) {menu_option_clear();}
	
	// Store the cursor's position before swapping over to the next section of the menu.
	lastSectionOption[curSection] = curOption;
	
	// Initializes the menu to whatever section is currently being opened. Everything else is automatic and 
	// handled by the parent menu's cursor movement code.
	switch(_sectionIndex){
		case ITEM_SECTION: // The section where the player stores their currently held items.
			menu_general_initialize(true, 4, 4, 6, 0, 0, 30, 0.4);
			// The title and options have all been initialized, so only certain portions of the variables 
			// for each needs to be altered for a given section.
			title = "Items";
			optionPos = [5, 18];
			optionSpacing = [20, 20];
			// Load in all the player's inventory data as options within the menu; their descriptions can
			// be found within the item's data that exists in a file outside of the game itself.
			var _name;
			for (var i = 0; i < global.invSize; i++){
				_name = global.invItem[i][0];
				if (_name != NO_ITEM) {menu_option_add(-1, _name, global.itemData[? ITEM_LIST][? _name][? DESCRIPTION], true);}
				else {menu_option_add(-1, _name, "", false);}
			}
			// Finally, set the correct state and drawing function for the section.
			set_cur_state(inventory_state_items_default);
			drawFunction = inventory_draw_item_section;
			break;
		case NOTE_SECTION: // The section where all the documents that have been found by the player can be viewed.
			menu_general_initialize(true, 1, 1, 10, 0, 0, 30, 0.4);
			// The title and options have all been initialized, so only certain portions of the variables 
			// for each needs to be altered for a given section.
			title = "Notes";
			optionPos = [5, 45];
			optionSpacing = [0, 12];
			optionAlign = [fa_left, fa_top];
			// Load in all the player's collect note data as options within the menu. None of them have
			// descriptions, so that portion of the option's struct data will be left blank.
			var _length = ds_list_size(global.invNote);
			for (var i = 0; i < _length; i++) {menu_option_add(-1, global.invNote[| i], "", true);}
			// Finally, set the correct state and drawing function for the section.
			set_cur_state(inventory_state_notes_default);
			drawFunction = inventory_draw_note_section;
			break;
		case MAP_SECTION: // The section where the player can look at all the maps they've acquired.
			menu_general_initialize(true, 0, 3, 1, 1, 0, 30, 0.4);
			// NOTE -- The menu's width is set to zero because it's just going to be set to the total number
			// of options in the menu, which is the number of maps the player has currently found.
			
			// The title and options have all been initialized, so only certain portions of the variables 
			// for each needs to be altered for a given section.
			title = "Maps";
			optionPos = [5, WINDOW_WIDTH - round(180 / 3)];
			optionSpacing = [60, 0];
			optionAlign = [fa_center, fa_top];
			// Finally, set the correct state and drawing function for the section.
			set_cur_state(inventory_state_maps_default);
			drawFunction = inventory_draw_map_section;
			break;
		default: // If no valid section was provided, the menu will be initialized as empty
			menu_general_initialize(true, 1, 0, 0, 0, 0, 30, 0.4);
			drawFunction = NO_SCRIPT; // No sub-menu will be drawn
			break;
	}
	
	// Finally, set the current section to whatever was placed into the argument space and the cursor back 
	// to the position it was last in before the player switched to the next section.
	curSection = _sectionIndex;
	menu_option_set_cur_option(lastSectionOption[_sectionIndex]);
}