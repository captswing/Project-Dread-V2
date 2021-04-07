/// @description Display General Debug Info

shader_set(outlineShader);
shader_set_uniform_i(sDrawOutline, 1);

draw_set_color(c_white);
shader_set_uniform_f_array(sOutlineColor, [0.5, 0.5, 0.5]);
outline_set_font(font_gui_small, global.fontTextures[? font_gui_small], sPixelWidth, sPixelHeight);

draw_set_halign(fa_right);
with(obj_cutscene){ // Display information about current cutscene
	var _head, _size;
	_head = ds_queue_head(sceneData);
	_size = ds_queue_size(sceneData);
	if (_size > 0) {draw_text(WINDOW_WIDTH - 5, WINDOW_HEIGHT - 20, "Queue Size: " + string(_size) + "\nCurrent Action: " + script_get_name(_head[0]));}
}

if (showItems){ // Showing the player's current inventory
	draw_text(WINDOW_WIDTH - 5, 5, "-- Inventory Data --");
	for(var i = 0; i < global.invSize; i++){
		draw_text(WINDOW_WIDTH - 5, 15 + (i * 10), global.invItem[i][0] + " x" + string(global.invItem[i][1]));
	}
}
draw_set_halign(fa_left);

if (!showDebugInfo){
	return;
}

draw_text(5, 5, "In-Game Playtime:\nDelta Time:\nRoom Size:\nInstances:\nDynamic Entities:\nStatic Entities:\nEntities Drawn:\nLights Drawn:\n\n-- Camera Data --\nPosition:\nFollowing:\n\n-- Player Data --\nCurrent State:\nLast State:\nPosition:\nMax Speed:\nHitpoints:\nCurrent Sanity:\nSanity Modifier:");

var _baseSanityMod, _playerID;
_baseSanityMod = global.isRoomSafe ? SANITY_MOD_SAFE : SANITY_MOD_UNSAFE;
_playerID = global.singletonID[? PLAYER];

shader_set_uniform_f_array(sOutlineColor, [0.5, 0, 0]);
draw_set_color(c_red);
draw_text(136, 5, global.playtimeString + "\n" +
				  string(global.deltaTime) + "\n" +
				  "[" + string(room_width) + ", " + string(room_height) + "]\n" + 
				  string(instance_number(all)) + "\n" + 
				  string(instance_number(par_dynamic_entity)) + "\n" +
				  string(instance_number(par_static_entity)) + "\n" +
				  string(global.singletonID[? DEPTH_SORTER].totalObjectsDrawn) + "\n" +
				  string(global.singletonID[? EFFECT_HANDLER].lightsDrawn) + "\n\n\n" +
				  "[" + string(x) + ", " + string(y) + "]\n" +
				  object_get_name(curObject.object_index) + "\n\n\n\n\n" +
				  "[" + string(_playerID.x) + ", " + string(_playerID.y) + "]\n" + 
				  "[" + string(_playerID.maxHspd) + ", " + string(_playerID.maxVspd) + "]\n" +
				  string(_playerID.hitpoints) + "/" + string(_playerID.maxHitpoints) + "\n" +
				  string(_playerID.curSanity) + "/" + string(_playerID.maxSanity) + "\n" +
				  string(_baseSanityMod + _playerID.sanityModifier));

draw_set_halign(fa_left);
draw_text(70, 5, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n" + 
				  script_get_name(_playerID.curState) + "\n" +
				  script_get_name(_playerID.lastState));

shader_reset();