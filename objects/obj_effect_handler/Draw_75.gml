/// @description Draw Screen-Space Effects

// The screen-space post processing effects are ordered as follows:
//		1	--		Film Grain
//		2	--		Scanlines
//		3	--		Screen Fade

if (global.settings[Settings.FilmGrain]){ // Activate the film grain effect if toggled on
	var _xOffset, _yOffset;
	_xOffset = irandom_range(0, noiseWidth);
	_yOffset = irandom_range(0, noiseHeight);
	draw_sprite_tiled_ext(spr_film_grain, 0, _xOffset, _yOffset, 1, 1, c_white, noiseStrength);
}

if (global.settings[Settings.Scanlines]){ // Activate the scanline effect if currently toggled
	scanline_effect(0.1);
}

if (fade != noone){ // Display the screen fade if the object exists
	draw_sprite_ext(spr_rectangle, 0, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0, fade.fadeColor, fade.alpha);
}