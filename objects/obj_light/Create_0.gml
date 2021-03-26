/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

image_speed = 0;
image_index = 0;
visible = false;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// The four variables used for drawing the light source. The size vector holds the x-axis radius and y-axis 
// radius for the light source. The strength is the alpha level used for the light source, ranging from any
// value between 0 and 1. The color is just the color of the light source itself.
size = [0, 0];
strength = 0;
color = c_white;

// A true light will be a source that can effect interactable objects, and whether or not the player can
// see and interact with them. A non-true light will be something that assists the player, such as the dim
// ambient light that surrounds them in complete darkness.
trueLight = false;

#endregion