/// @description Variable Initialization

// Add the object as a singleton to prevent duplicates. If it fails, exit the create event early.
if (!add_singleton_object()) {return;}

#region EDITING INHERITED VARIABLES

image_speed = 0;
image_index = 0;
visible = true;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Variable for Storing the Screen Fade Object /////////////////////////////////////

// Holds the instance ID of the "Lightweight" screen fade object that handles any screen
// fades that are needed by other objects. (Cutscenes, menus, etc.)
fade = noone;

////////////////////////////////////////////////////////////////////////////////////

// Variables for the Current Weather Effect ////////////////////////////////////////

// Stores the "Lightweight" object that handles the game's current weather effect. Also, the 
// currently active weather type is tracked for when the weather is changed. Updating and
// drawing the weather is all handled in the effect handler.
weather = noone;
weatherType = Weather.Clear;

////////////////////////////////////////////////////////////////////////////////////

// Variables that store the resulting surface after all effects have been processed; with two auxillary
// surfaces that act as buffers to store the application surface whenever multiple passes are used in 
// a shader's effect.
resultSurface = -1;
auxSurfaceA = -1;
auxSurfaceB = -1;

// These three variables store the texture ID for the result and auxillary surfaces that cna easily be
// passed to the currently active shader.
resultTexture = -1;
auxTextureA = -1;
auxTextureB = -1;

// Variables for Lighting Shader ///////////////////////////////////////////////////

// This variable holds a reference to the shader's unique asset index value.
lightShader = shd_lighting;
// Get the uniform locations; storing them in local variables
sColor =			shader_get_uniform(lightShader, "color");
sBrightness =		shader_get_uniform(lightShader, "brightness");
sContrast =			shader_get_uniform(lightShader, "contrast");
sSaturation =		shader_get_uniform(lightShader, "saturation");
sLightTexture =		shader_get_sampler_index(lightShader, "lightTexture");

// A flag that toggles the lighting system on and off.
lightingEnabled = true;

// The variables that effect the global light's overall color, brightness, contrast, and saturation.
lightColor =		[0, 0, 0];
lightBrightness =  -0.55;
lightContrast =		0.28;
lightSaturation =	0.43;

// Keeps track of how many lights are currently being drawn by the lighting system
lightsDrawn = 0;

////////////////////////////////////////////////////////////////////////////////////

// Variable for the Bloom Shaders //////////////////////////////////////////////////

// This variable holds a reference to the shader's unique asset index value.
bloomShaderLuminence = shd_bloom_luminence;
// Get the uniform locations; storing them in local variables
sBloomThreshold =	shader_get_uniform(bloomShaderLuminence, "bloomThreshold");
sBloomRange =		shader_get_uniform(bloomShaderLuminence, "bloomRange");

// This variable holds a reference to the shader's unique asset index value.
bloomShaderBlend = shd_bloom_blend;
// Get the uniform locations; storing them in local variables
sBloomIntensity =	shader_get_uniform(bloomShaderBlend, "bloomIntensity");
sBloomDarken =		shader_get_uniform(bloomShaderBlend, "bloomDarken");
sBloomSaturation =	shader_get_uniform(bloomShaderBlend, "bloomSaturation");
sBloomTexture =		shader_get_sampler_index(bloomShaderBlend, "bloomTexture");

////////////////////////////////////////////////////////////////////////////////////

// Variables for the Blur Shader ///////////////////////////////////////////////////

// This variable holds a reference to the shader's unique asset index value.
blurShader = shd_blur;
// Get the uniform locations; storing them in local variables
sBlurSteps =		shader_get_uniform(blurShader, "blurSteps");
sTexelSize =		shader_get_uniform(blurShader, "texelSize");
sSigma =			shader_get_uniform(blurShader, "sigma");
sBlurVector =		shader_get_uniform(blurShader, "blurVector");

// A flag that toggles the blur effect on and off.
blurEnabled = false;

////////////////////////////////////////////////////////////////////////////////////

// Variables for the Chromatic Aberration Shader ///////////////////////////////////

// This variable holds a reference to the shader's unique asset index value.
abrerrationShader = shd_chromatic_aberration;
// Get the uniform locations; storing them in local variables
sAberration =		shader_get_uniform(abrerrationShader, "aberration");

////////////////////////////////////////////////////////////////////////////////////

// Variables for the Scanline Shader ///////////////////////////////////////////////

// This variable holds a reference to the shader's unique asset index value.
scanlineShader = shd_scanlines;
// Get the uniform locations; storing them in local variables
sViewHeight =		shader_get_uniform(scanlineShader, "viewHeight");
sStrength =			shader_get_uniform(scanlineShader, "strength");

////////////////////////////////////////////////////////////////////////////////////

// Variables for the Film Grain Effect /////////////////////////////////////////////

// Store the width and height of the film grain sprite in two variables. Prevents having
// to constantly fetch these values every single frame; despite the fact that none of the
// dimensions will ever change during runtime.
noiseWidth = sprite_get_width(spr_film_grain);
noiseHeight = sprite_get_height(spr_film_grain);

// Also, store the intensity of the noise effect in another variable for easily potential
// adjustments to it later down the line.
noiseStrength = 0.15;

////////////////////////////////////////////////////////////////////////////////////

// Disable the automatic drawing of the application surface
application_surface_draw_enable(false);

#endregion/