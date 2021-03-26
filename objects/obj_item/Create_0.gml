/// @description Editing Inherited Variable/Unique Variable Initialization

#region EDITING INHERITED VARIABLES

// Initialize all variables from the static entity parent object, which include state stuff.
event_inherited();
// Set the script to add an item to the inventory
interactScript = collect_item;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Stores the key value for this item's reference within the world_item_data map. If the map's quantity
// has a zero, this object is deleted and the index is removed from the map.
keyIndex = -1;

#endregion