/// @description Draw Screen-Space Effects

// The screen-space post processing effects are ordered as follows:
//		1	--		Film Grain/Noise
//		2	--		Scanlines

if (global.settings[Settings.FilmGrain]){
	film_grain_effect(filmGrainWidth, 0.08, 4);
}

if (global.settings[Settings.Scanlines]){
	scanline_effect(WINDOW_HEIGHT, 0.1);
}