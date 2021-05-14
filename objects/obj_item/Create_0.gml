/// @description Editing Inherited Variable/Unique Variable Initialization

#region EDITING INHERITED VARIABLES

// Initialize all variables from the static entity parent object, which include state stuff.
event_inherited();
// Makes the object sit lower toward the ground than objects like the player; simulating that the item is
// below the player instead of at the same height as them.
zOffset = -4;
// Set the script to add an item to the inventory
interactScript = collect_item;
// Set the optional interaction text to be specific to items
interactionText = "Pick Up Item";

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Stores the key value for this item's reference within the world_item_data map. If the map's quantity
// has a zero, this object is deleted and the index is removed from the map.
keyIndex = -1;

#endregion