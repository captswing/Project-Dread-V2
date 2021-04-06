/// @description Check if Item Collected/Gather Item Data if Not

if (is_undefined(global.worldItemData[? keyIndex]) || global.worldItemData[? keyIndex][? QUANTITY] <= 0){
	instance_destroy(self);
	return;
}

// UNIQUE CASE -- When the item is an item pouch, the script used during interaction is different
if (global.worldItemData[? keyIndex][? NAME] == ITEM_POUCH){
	interactScript = collect_inventory_expansion;
}

// UNIQUE CASE -- When the item is a cassette tape, only allow it to exist when limited saves are
// toggled in the files gameplay settings.
if (global.worldItemData[? keyIndex][? NAME] == CASSETTE_TAPE && !global.gameplay.limitedSaves){
	ds_map_delete(global.worldItemData, keyIndex); // No use for the data, so delete it
	instance_destroy(self);
}