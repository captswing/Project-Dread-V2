/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

// Initialize variables found in the parent's create event
event_inherited();
// Sets the player's maximum hspd and vspd
entity_set_max_speed(1.25, 1.25, true);
// Initialize the inherited sprite variables with the entity's default sprites
standSprite = spr_claire_unarmed_stand;
walkSprite = spr_claire_unarmed_walk;

#endregion