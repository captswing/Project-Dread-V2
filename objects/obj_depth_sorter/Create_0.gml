/// @description Variable Initialization

// Add the object as a singleton to prevent duplicates. If it fails, exit the create event early.
if (!add_singleton_object()) {return;}

#region EDITING INHERITED VARIABLES

image_speed = 0;
image_index = 0;
visible = true;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Tracks the number of objects drawn by this object in the current frame. Used for validating that culling
// is working on off-screen sprites.
totalObjectsDrawn = 0;

// Store the ID for the outline shader used for drawing a one pixel wide outline around an object. Used
// primarily for text and for interactables if the outlines are enabled in the accessibility menu.
outlineShader = shd_outline;
// Get the uniform locations; storing them in local variables
sPixelWidth =		shader_get_uniform(outlineShader, "pixelWidth");
sPixelHeight =		shader_get_uniform(outlineShader, "pixelHeight");
sOutlineColor =		shader_get_uniform(outlineShader, "outlineColor");
sDrawOutline =		shader_get_uniform(outlineShader, "drawOutline");

#endregion