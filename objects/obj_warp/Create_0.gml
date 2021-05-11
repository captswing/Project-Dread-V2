/// @description Editing Inherited Variable/Unique Variable Initialization

#region EDITING INHERITED VARIABLES

// Initialize all variables from the static entity parent object, which include state stuff.
event_inherited();
// Adjust some of the interaction variables to fit the warp better
interactRadius = 10;
interactCenter = [x + 8, y + 4];
// Set the interation script to be the script involving room warping/key checking.
interactScript = interact_room_warp;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Stores the event flag that corresponds to this door if it's locked. If the door isn't locked this variable
// is never used so no event flags will be altered by the door.
eventFlagIndex = -1;

// A list that contains all the items AKA keys required to open this door. If the list is left as an empty
// list structure, the door will be considered "unlocked" and allow warping from the getgo. Otherwise, all
// the keys in this list will need to be in the player's inventory for them to open the door.
requiredKeys = ds_list_create();

// Stores the player's target position they'll be warped to, as well as the index for the room they will be
// warped to.
targetX = 0;
targetY = 0;
targetRoom = -1;

// The three sounds that can be unique to each warp object by way of their creation code. Each of these 
// variables stores a sound for the door being locked, opening, and closing, respectively.
doorLockedSound = -1;
doorOpenSound = -1;
doorCloseSound = -1;

#endregion