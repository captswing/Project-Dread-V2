/// @description Holds all the code for processing the simple lighting shader. First it goes through all existing
/// and visible light sources in the room and draws them to a surface. After that, the shader effect is applied
/// with the light surface; resulting in the final result output onto the screen.
/// @param [r/g/b]
/// @param brightness
/// @param contrast
/// @param saturation
function lighting_system(_lightColor, _brightness, _contrast, _saturation){
	// Begin by drawing all the light sources onto a texture
	surface_set_target(auxSurfaceA);

	// Completely black out the lighting surface before drawing the lights to it
	draw_clear(c_black);
	gpu_set_blendmode(bm_add);
	gpu_set_tex_filter(true);

	// Store the top-left coordinate of the camera for easy reuse
	var _cameraX, _cameraY, _lightsDrawn;
	_cameraX = camera_get_x();
	_cameraY = camera_get_y();
	_lightsDrawn = 0;
	with(obj_light){ // Display every visible light instance onto the light surface
		if (x + size[X] < _cameraX || y + size[Y] < _cameraY || x - size[X] > _cameraX + WINDOW_WIDTH || y - size[Y] > _cameraY + WINDOW_HEIGHT){
			continue; // The light is off of the screen; don't bother drawing the light
		}
		// Draw the light based on its radius, color, and strength
		draw_set_alpha(strength);
		draw_ellipse_color(x - size[X] - _cameraX, y - size[Y] - _cameraY, x + size[X] - _cameraX, y + size[Y] - _cameraY, color, c_black, false);
		draw_set_alpha(1);
		// Let the light system know that the light was drawn
		_lightsDrawn++;
	}

	// Finally, reset the GPU and surface target
	gpu_set_tex_filter(false);
	gpu_set_blendmode(bm_normal);
	surface_reset_target();

	// After adding all the lights to their surface, render the lighting system with its shader
	shader_set(lightShader);
	// Set all the uniforms to their corresponding values
	shader_set_uniform_f_array(sColor, _lightColor);
	shader_set_uniform_f(sBrightness, _brightness);
	shader_set_uniform_f(sContrast, _contrast);
	shader_set_uniform_f(sSaturation, _saturation);
	texture_set_stage(sLightTexture, auxTextureA);

	surface_set_target(resultSurface);
	draw_surface(application_surface, 0, 0);
	surface_reset_target();

	shader_reset();
	
	return _lightsDrawn;
}

/// @description Holds all the code for processing the bloom effect for the game. This makes bright areas appear
/// brighter on the screen, with a semi-transparent glow around them relative to the strength of the bloom effect.
/// @param bloomThreshold
/// @param bloomRange
/// @param blurSteps
/// @param sigma
/// @param bloomIntensity
/// @param bloomDarken
/// @param bloomSaturation
function bloom_effect(_bloomThreshold, _bloomRange, _blurSteps, _sigma, _bloomIntensity, _bloomDarken, _bloomSaturation){
	// Store the unaltered result surface in the second auxillary surface to avoid overwritting during the blurring process
	surface_copy(auxSurfaceB, 0, 0, resultSurface);
	
	// First pass: Draw bright areas to resultSurface
	shader_set(bloomShaderLuminence);
	// Set all the uniforms to their corresponding values
	shader_set_uniform_f(sBloomThreshold, _bloomThreshold);
	shader_set_uniform_f(sBloomRange, _bloomRange);
	
	surface_set_target(resultSurface);
	draw_surface(auxSurfaceB, 0, 0);
	surface_reset_target();
	
	shader_reset();
	
	// Apply the blur effect to the areas that will be bloomed
	blur_effect(_blurSteps, _sigma);

	// Third pass: Blend the blurred surface with the stored result surface
	shader_set(bloomShaderBlend);
	// Set all the uniforms to their corresponding values
	shader_set_uniform_f(sBloomIntensity, _bloomIntensity);
	shader_set_uniform_f(sBloomDarken, _bloomDarken);
	shader_set_uniform_f(sBloomSaturation, _bloomSaturation);
	texture_set_stage(sBloomTexture, resultSurface);
	
	surface_set_target(resultSurface);
	draw_surface(auxSurfaceB, 0, 0);
	surface_reset_target();

	shader_reset();
}

/// @description Holds all the code for processing a two-step blur shader effect. The first pass is a horizontal
/// blur, (Although, order doesn't matter) and that result is stored into the buffer surface. The second pass
/// takes that buffer and draws it to the application surface with a vertical blur applied.
/// @param blurSteps
/// @param sigma
function blur_effect(_blurSteps, _sigma) {
	// Begin drawing using the blur shader's 2-pass system
	shader_set(blurShader);
	// Set all the uniforms to their corresponding values
	shader_set_uniform_f(sTexelSize, 1 / WINDOW_WIDTH, 1 / WINDOW_HEIGHT);
	shader_set_uniform_f(sBlurSteps, _blurSteps);
	shader_set_uniform_f(sSigma, _sigma);

	// The first pass: horizontal blurring
	shader_set_uniform_f(sBlurVector, 1, 0); // [1, 0] tells the shader to blur horizontally
	surface_set_target(auxSurfaceA);
	draw_surface(resultSurface, 0, 0);
	surface_reset_target();

	// The second pass: vertical blurring
	shader_set_uniform_f(sBlurVector, 0, 1); // [0, 1] tells the shader to blur vertically
	surface_set_target(resultSurface);
	draw_surface(auxSurfaceA, 0, 0);
	surface_reset_target();

	shader_reset();
}

/// @description Holds the code for processing the chromatic aberration shader effect. It's a simple shader
/// where colors get more distorted the further from the center the pixel is on the application surface.
/// @param aberration
function aberration_effect(_aberration){
	shader_set(abrerrationShader);
	// Set the uniform to its corresponding value.
	shader_set_uniform_f(sAberration, _aberration);

	// Draw the aberration effect to the first auxillary surface
	surface_set_target(auxSurfaceA);
	gpu_set_tex_filter(true); // Without a linear filter this shader looks like garbage

	draw_surface(resultSurface, 0, 0);

	gpu_set_tex_filter(false);
	surface_reset_target();

	shader_reset();
	
	surface_set_target(resultSurface);
	draw_surface(auxSurfaceA, 0, 0);
	surface_reset_target();
}

/// @description Holds the code that handles the scanline shader on the GUI surface. It's a very simple shader 
/// that applies a black line to each even pixel relative to the height. The strength of the effect determines
/// how pronounced the scanlines are.
/// @param strength
function scanline_effect(_strength){
	shader_set(scanlineShader);
	// Set the uniforms to their corresponding values.
	shader_set_uniform_f(sViewHeight, WINDOW_HEIGHT);
	shader_set_uniform_f(sStrength, _strength);

	// Draw the surface to the screen; applying the shader's effect to it
	draw_surface(resultSurface, 0, 0);

	shader_reset();
}