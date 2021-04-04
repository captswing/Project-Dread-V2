/// @description Display General Debug Info

shader_set(outlineShader);
shader_set_uniform_i(sDrawOutline, 1);

draw_set_color(c_white);
shader_set_uniform_f_array(sOutlineColor, [0.5, 0.5, 0.5]);
outline_set_font(font_gui_small, global.fontTextures[? font_gui_small], sPixelWidth, sPixelHeight);

draw_set_halign(fa_right);
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

var _baseSanityMod = global.isRoomSafe ? SANITY_MOD_SAFE : SANITY_MOD_UNSAFE;

shader_set_uniform_f_array(sOutlineColor, [0.5, 0, 0]);
draw_set_color(c_red);
draw_text(136, 5, global.playtimeString + "\n" +
				  string(global.deltaTime) + "\n" +
				  "[" + string(room_width) + ", " + string(room_height) + "]\n" + 
				  string(instance_number(all)) + "\n" + 
				  string(instance_number(par_dynamic_entity)) + "\n" +
				  string(instance_number(par_static_entity)) + "\n" +
				  string(global.sorterID.totalObjectsDrawn) + "\n" +
				  string(global.effectID.lightsDrawn) + "\n\n\n" +
				  "[" + string(x) + ", " + string(y) + "]\n" +
				  object_get_name(curObject.object_index) + "\n\n\n\n\n" +
				  "[" + string(global.playerID.x) + ", " + string(global.playerID.y) + "]\n" + 
				  "[" + string(global.playerID.maxHspd) + ", " + string(global.playerID.maxVspd) + "]\n" +
				  string(global.playerID.hitpoints) + "/" + string(global.playerID.maxHitpoints) + "\n" +
				  string(global.playerID.curSanity) + "/" + string(global.playerID.maxSanity) + "\n" +
				  string(_baseSanityMod + global.playerID.sanityModifier));

draw_set_halign(fa_left);
draw_text(70, 5, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n" + 
				  script_get_name(global.playerID.curState) + "\n" +
				  script_get_name(global.playerID.lastState));

shader_reset();