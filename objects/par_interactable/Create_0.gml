/// @description Editing Inherited Variables/Unique Variable Initialization

#region EDITING INHERITED VARIABLES

// Ensures that the player can walk through interactables
mask_index = spr_empty_collider;

// Initialize all variables from the static entity parent object, which include state stuff.
event_inherited();
// An outline will be drawn if the accessibility setting is toggled
drawOutline = true;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Handles the whole interaction-side of things for the object. The first variable is a flag that allows the
// player to actually interact with the object or not. If it's in the darkness -- and the player doesn't have
// their flashlight on -- they can't interact, and vice verse. The second variable stores the position for the 
// center point of the interaction radius, since the origin of the sprite won't always be in the center. Next, 
// the third variable is the distance from the object the player needs to be in order to interact with it. 
// Finally, the script stores the function that handles what happens when an interaction occurs.
canInteract = false;
interactCenter = [x, y];
interactRadius = 8;
interactScript = NO_SCRIPT;

// This flag causes a check for the nearest true light source to occur for the interactable. After that, it's
// set to false and whatever it calculated with determine if the object can be interacted with by the player.
checkForLights = true;

// Flavor text for the interation prompt that can be enabled or disabled from the game's accessibility settings.
// It shows up next to the binding for the game's controls; specifically the keybinding for interaction.
interactionText = "Inspect";

#endregion