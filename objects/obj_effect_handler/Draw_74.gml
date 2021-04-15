/// @description Draw World-Space Effects

// The result shader is used on multiple occasions to store the effect of a previous shader in order to 
// correctly apply it to another shader. Also gets texture ID for any shaders that need to use it
if (!surface_exists(resultSurface)){
	resultSurface = surface_create(WINDOW_WIDTH, WINDOW_HEIGHT);
	resultTexture = surface_get_texture(resultSurface);
}

// The first auxillary surface that is used to store any effects that are being processed by a shader. 
// Also gets the textureID for the same purpose.
if (!surface_exists(auxSurfaceA)){
	auxSurfaceA = surface_create(WINDOW_WIDTH, WINDOW_HEIGHT);
	auxTextureA = surface_get_texture(auxSurfaceA);
}

// The second auxillary surface that is used to store any effects that are being processed by a shader. 
// Also gets the texture ID for the same purpose.
if (!surface_exists(auxSurfaceB)){
	auxSurfaceB = surface_create(WINDOW_WIDTH, WINDOW_HEIGHT);
	auxTextureB = surface_get_texture(auxSurfaceB);
}

// Before anything is processed, store the application surface onto the result surface
surface_set_target(resultSurface);
draw_surface(application_surface, 0, 0);
surface_reset_target();

// The world-space post processing effects are ordered as follows:
//		1	--		Lighting System
//		2	--		Bloom
//		3	--		Blur
//		4	--		Chromatic Abberation

if (lightingEnabled){ // Activate lighting system if currently enabled
	lightsDrawn = lighting_system(lightColor, lightBrightness, lightContrast, lightSaturation);
}

if (global.settings[Settings.Bloom]){ // Activate the bloom effect if currently enabled
	bloom_effect(0.9, 0.1, 3, 0.15, 0.75, 0.9, 0.7);
}

if (blurEnabled){ // Activate blur effect if currently enabled
	blur_effect(3, 0.25);
}

if (global.settings[Settings.Aberration]){ // Activate the aberration effect if currently enabled
	aberration_effect(0.15);
}

// Draw the final surface to the screen with all active post-processing effects applied
draw_surface(resultSurface, 0, 0);