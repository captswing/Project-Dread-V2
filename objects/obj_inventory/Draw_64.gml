/// @description Drawing the Main Menu Background/Information and the Current Section As Well

// 
draw_sprite_general(spr_rectangle, 0, 0, 0, 1, 1, 0, 0, WINDOW_WIDTH, 13, 0, c_black, c_black, c_dkgray, c_dkgray, image_alpha * 0.75);
draw_sprite_ext(spr_rectangle, 0, 0, 13, WINDOW_WIDTH, 1, 0, c_black, image_alpha);

// Drawing all the required text for the inventory between the outline shader's initialization and reset
shader_set(outlineShader);
shader_set_uniform_i(sDrawOutline, 1);

// All sections use the title, so it will be drawn outside of each of their respective functions
menu_draw_title();

// The current outline color doesn't need to be reset when this shader pass is reset, but only when the menu
// itself has completed drawing everything for the current frame.
shader_reset();

// Display the current section only if a valid draw function was provided
if (drawFunction != NO_SCRIPT) {script_execute(drawFunction);}