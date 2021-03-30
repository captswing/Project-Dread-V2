/// @description Stores the "Height" of the collider

#region EDITING INHERITED VARIABLES

image_index = 0;
image_speed = 0;
visible = false;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// This is compared with the zOffset of both hitscans and projectiles; allowing for the object to pass over
// short objects (Ex. coffee tables, couches, etc.) but not walls and other taller colliders.
colliderHeight = 0;

#endregion