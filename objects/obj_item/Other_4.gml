/// @description Check if Item Collected/Gather Item Data if Not

if (is_undefined(global.worldItemData[? keyIndex]) || global.worldItemData[? keyIndex][? QUANTITY] <= 0){
	instance_destroy(self);
	return;
}