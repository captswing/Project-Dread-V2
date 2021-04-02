/// @description Draw Screen-Space Effects

// Set the alpha level to 1 always
draw_set_alpha(1);

// The screen-space post processing effects are ordered as follows:
//		1	--		Film Grain/Noise
//		2	--		Scanlines

if (global.settings[Settings.FilmGrain]){
	film_grain_effect(filmGrainWidth, 0.08, 3.8);
}

if (global.settings[Settings.Scanlines]){
	scanline_effect(WINDOW_HEIGHT, 0.1);
}