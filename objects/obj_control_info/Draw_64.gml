/// @description Display All Current Control Information

// 
var _length = ds_list_size(controlData);
if (_length == 0 || alpha <= 0) {return;} // Don't waste time drawing if no control data exists or it's invisible

//
draw_sprite_ext(spr_rectangle, 0, 0, WINDOW_HEIGHT - 14, WINDOW_WIDTH, 1, 0, c_black, alpha);
draw_sprite_general(spr_rectangle, 0, 0, 0, 1, 1, 0, WINDOW_HEIGHT - 13, WINDOW_WIDTH, 13, 0, c_dkgray, c_dkgray, c_black, c_black, alpha * 0.75);

// 
draw_set_alpha(alpha);

// 
shader_set(outlineShader);
shader_set_uniform_i(sDrawOutline, 1);

// 
draw_set_color(c_white);
shader_set_uniform_f_array(sOutlineColor, [0.5, 0.5, 0.5]);
outline_set_font(font_gui_small, global.fontTextures[? font_gui_small], sPixelWidth, sPixelHeight);

// 
for (var i = 0; i < _length; i++){
	with(controlData[| i]){ // Draws the text at the calculated position with the correct alignment
		if (anchor == RIGHT_ANCHOR) {draw_set_halign(fa_right);}
		else if (anchor == LEFT_ANCHOR) {draw_set_halign(fa_left);}
		draw_text(textPos[X], textPos[Y], infoText);
	}
}
draw_set_halign(fa_left);

// 
shader_reset();

// 
var _data;
for (var i = 0; i < _length; i++) {
	with(controlData[| i]){ // Draws the control's icon at the calculated position relative to its anchor
		_data = global.controlIcons[? iconKey];
		if (anchor == RIGHT_ANCHOR) {draw_sprite(_data[0], _data[1], sprPos[X] - sprite_get_width(_data[0]), sprPos[Y]);}
		else if (anchor == LEFT_ANCHOR) {draw_sprite(_data[0], _data[1], sprPos[X], sprPos[Y]);}
	}
}