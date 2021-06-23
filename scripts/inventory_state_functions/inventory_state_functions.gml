/// STATES FOR THE ITEM SECTION OF THE INVENTORY ///////////////////////////////////

/// @description
function inventory_state_items_default(){
	// First, check if the section needs to be swapped of if the menu is closing. If so, exit this state early.
	if (inventory_section_swap_input() || inventory_exit_input()) {return;}
	
	// The menu's cursor can be moved around the inventory in this state.
	menu_cursor_movement();
}

////////////////////////////////////////////////////////////////////////////////////

/// STATES FOR THE NOTE SECTION OF THE INVENTORY ///////////////////////////////////

/// @description
function inventory_state_notes_default(){
	// First, check if the section needs to be swapped of if the menu is closing. If so, exit this state early.
	if (inventory_section_swap_input() || inventory_exit_input()) {return;}
	
	// The menu's cursor can be moved around the player's current notes in this state
	menu_cursor_movement();
}

////////////////////////////////////////////////////////////////////////////////////

/// STATES FOR THE MAP SECTION OF THE INVENTORY ////////////////////////////////////

/// @description
function inventory_state_maps_default(){
	// First, check if the section needs to be swapped of if the menu is closing. If so, exit this state early.
	if (inventory_section_swap_input() || inventory_exit_input()) {return;}
	
	// The menu's cursor can be moved around the inventory in this state.
	menu_cursor_movement();
}

////////////////////////////////////////////////////////////////////////////////////