/// @description Draw the Currently Active Textbox

// Set the alpha for the entire textbox
draw_set_alpha(alpha);

// Get a reference to the struct stored within the list for the current actor. Also, find out if the
// namespace section of the textbox needs to be displayed for the speaker's name.
var _data, _showName;
_data = actorData[? textboxData[| textboxIndex][1]];
_showName = (_data.firstName != "NoActor");

// Drawing the textbox's background and the currently visible text right after that
draw_sprite_stretched_ext(_data.textboxSprite, 0, x + 5, y, WINDOW_WIDTH - 10, 52, _data.textboxColor, alpha);
// Optionally, display the namespace when required to display the speaker's name
if (_showName) {draw_sprite_stretched_ext(_data.namespaceSprite, 0, x + 18, y - 11, 70, 13, _data.textboxColor, alpha);}

// Show an indicator that the text is fully visible and the player can move on.
if (nextCharacter >= finalCharacter) {draw_sprite(spr_textbox_indicator, 0, x + WINDOW_WIDTH - 20, y + 42 + floor(indicatorOffset));}

// Set the shader for drawing outlines around the visible text
shader_set(outlineShader);
shader_set_uniform_i(sDrawOutline, 1);

// Set the font, and color of the text; outline included
outline_set_color(c_white, [0.5, 0.5, 0.5], sOutlineColor, -1);
currentFont = outline_set_font(font_gui_small, global.fontTextures[? font_gui_small], sPixelWidth, sPixelHeight, currentFont);

// Displays the actor's name, portrait, and text they are currently saying to the screen. The name and
// portrait are optional aspects of the textbox, and thus don't need to be drawn all the time.
if (_showName){// Displays the actor's name within the namespace field
	draw_text(x + 25, y - 7, _data.firstName);
}
// Only display the portrait if it isn't set to -1, which means no portrait sprite exists
if (_data.portraitSprite != -1){
	draw_text(x + 72, y + 10, visibleText); // Offset the text to fit the character portarit
	shader_reset();
	// After resetting the shader, draw the portrait sprite to the screen
	draw_sprite(_data.portraitSprite, textboxData[| textboxIndex][2], x + 20, y + 3);
} else{ // Draw the text as normal if no portrait exists
	draw_text(x + 20, y + 10, visibleText);
	shader_reset();
}

// Finally, reset the alpha level to prevent any weird opacity issues
draw_set_alpha(1);