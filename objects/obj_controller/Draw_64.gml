/// @description  Screen Space Effects and Display General Debug Info

// DEBUGGING STUFF BELOW HERE (WILL BE DELETED EVENTUALLY)

shader_set(outlineShader);
shader_set_uniform_i(sDrawOutline, 1);

draw_set_color(c_white);
shader_set_uniform_f_array(sOutlineColor, [0.5, 0.5, 0.5]);
outline_set_font(font_gui_small, global.fontTextures[? font_gui_small], sPixelWidth, sPixelHeight);

draw_set_halign(fa_right);
with(obj_cutscene){ // Display information about current cutscene
	var _size = ds_list_size(sceneData);
	draw_text(WINDOW_WIDTH - 5, WINDOW_HEIGHT - 20, "Instruction Index: " + string(sceneIndex) + "/" + string(_size) + "\nCurrent Action: " + script_get_name(sceneData[| sceneIndex][0]));
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

// Getting the number of objects drawn by the depth sorter
var _totalObjectsDrawn = 0;
with(global.singletonID[? DEPTH_SORTER]) {_totalObjectsDrawn = totalObjectsDrawn;}

// Getting the number of lights drawn by the lighting shader
var _totalLightsDrawn = 0;
with(global.singletonID[? EFFECT_HANDLER]) {_totalLightsDrawn = lightsDrawn;}

// Getting the camera's followed object's index
var _objectIndex = noone;
with(curObject) {_objectIndex = object_index;}

// Getting player information for the debug HUD
var _baseSanityMod, _x, _y, _maxHspd, _maxVspd, _hitpoints, _maxHitpoints, _sanity, _maxSanity, _sanityModifier, _curState, _lastState;
_baseSanityMod = global.isRoomSafe ? SANITY_MOD_SAFE : SANITY_MOD_UNSAFE;
with(global.singletonID[? PLAYER]){
	_x = x;
	_y = y;
	
	_maxHspd = maxHspd;
	_maxVspd = maxVspd;
	
	_hitpoints = hitpoints;
	_maxHitpoints = maxHitpoints;
	
	_sanity = curSanity;
	_maxSanity = maxSanity;
	_sanityModifier = sanityModifier;
	
	_curState = curState;
	_lastState = lastState;
}

shader_set_uniform_f_array(sOutlineColor, [0.5, 0, 0]);
draw_set_halign(fa_right);
draw_set_color(c_red);
draw_text(136, 5, global.playtimeString + "\n" +
				  string(global.deltaTime) + "\n" +
				  "[" + string(room_width) + ", " + string(room_height) + "]\n" + 
				  string(instance_number(all)) + "\n" + 
				  string(instance_number(par_dynamic_entity)) + "\n" +
				  string(instance_number(par_static_entity)) + "\n" +
				  string(_totalObjectsDrawn) + "\n" +
				  string(_totalLightsDrawn) + "\n\n\n" +
				  "[" + string(x) + ", " + string(y) + "]\n" +
				  object_get_name(_objectIndex) + "\n\n\n\n\n" +
				  "[" + string(_x) + ", " + string(_y) + "]\n" + 
				  "[" + string(_maxHspd) + ", " + string(_maxVspd) + "]\n" +
				  string(_hitpoints) + "/" + string(_maxHitpoints) + "\n" +
				  string(_sanity) + "/" + string(_maxSanity) + "\n" +
				  string(_baseSanityMod + _sanityModifier));

draw_set_halign(fa_left);
draw_text(70, 5, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n" + 
				  script_get_name(_curState) + "\n" +
				  script_get_name(_lastState));

shader_reset();