/// @description Draw the Currently Active Textbox

// Get a reference to the struct stored within the list for the current actor. Also, find out if the
// namespace section of the textbox needs to be displayed for the speaker's name.
var _data, _showName;
_data = actorData[? textboxData[| 0][1]];
_showName = (_data.firstName != "NoActor");

// Drawing the textbox's background and the currently visible text right after that
draw_sprite_stretched_ext(_data.textboxSprite, 0, x + 5, y, WINDOW_WIDTH - 10, 55, _data.textboxColor, alpha);
// Optionally, display the namespace when required to display the speaker's name
if (_showName) {draw_sprite_stretched_ext(_data.namespaceSprite, 0, x + 18, y - 11, namespaceWidth, 13, _data.textboxColor, alpha);}

// Set the shader for drawing outlines around the visible text
shader_set(outlineShader);
shader_set_uniform_i(sDrawOutline, 1);

// Set the font, alpha, and color of the text; outline included
draw_set_alpha(alpha);
draw_set_color(c_white);
shader_set_uniform_f_array(sOutlineColor, [0.5, 0.5, 0.5]);
outline_set_font(font_gui_small, global.fontTextures[? font_gui_small], sPixelWidth, sPixelHeight);

// Drawing the actor's name and portrait to the screen if an actor is associated with the current textbox
if (_showName){
	draw_text(x + 25, y - 7, _data.firstName);
	// TODO -- Add portrait images here
}

// Draw the current visible textbox contents to the screen
draw_text(x + 20, y + 10, visibleText);

shader_reset();