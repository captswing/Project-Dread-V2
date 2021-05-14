/// @description Editing Inherited Variables

#region EDITING INHERITED VARIABLES

// Initialize all variables from the static entity parent object, which includes state stuff.
event_inherited();
// Re-enable the mask by setting it after exiting the parent object's create event
mask_index = sprite_index;
// Set the height of the object for projectile collision handling
colliderHeight = 8;
// Adjust the z-offset to prevent sprites overlapping improperly
zOffset = 4;
// Set up the interaction information for the object
interactCenter = [x + 8, y + 8];
interactScript = interact_apartment_general;

#endregion

#region UNIQUE VARIABLE INITIALIZATION
#endregion