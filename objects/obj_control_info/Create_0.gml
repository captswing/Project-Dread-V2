/// @description Variable Initialization

// Add the object as a singleton to prevent duplicates. If it fails, exit the create event early.
if (!add_singleton_object()) {return;}

#region EDITING INHERITED VARIABLES

image_index = 0;
image_alpha = 0;
image_speed = 0;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Holds the index for the shader used for outlining the text
outlineShader = shd_outline;
// Getting the uniforms for the shader; storing them in local variables
sPixelWidth = shader_get_uniform(outlineShader, "pixelWidth");
sPixelHeight = shader_get_uniform(outlineShader, "pixelHeight");
sOutlineColor = shader_get_uniform(outlineShader, "outlineColor");
sDrawOutline = shader_get_uniform(outlineShader, "drawOutline");

// 
leftAnchor = [5, WINDOW_HEIGHT - 10];
rightAnchor = [WINDOW_WIDTH - 5, WINDOW_HEIGHT - 10];

// 
controlData = ds_list_create();

//
alpha = 0;

#endregion