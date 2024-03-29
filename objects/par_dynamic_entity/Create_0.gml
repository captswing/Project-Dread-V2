/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

image_speed = 0;
image_index = 0;
visible = false;

#endregion

#region UNIQUE VARIABLE INITIAILZATION

// This flag enables/disables the outline shader's effect on an object. However, if the setting is enabled
// outright; all outlined objects will be enabled as well. Likewise for when disabled.
drawOutline = false;

// A variable that stores a method's ID value. Whenever the variable is used, the relative state code will
// be executed, and for only that state's code. The lastState variable stores the previously active state.
curState = -1;
lastState = -1;

// The entity's current horizontal and vertical movement velocity, respectively.
hspd = 0;
vspd = 0;

// The 2.5D offset that allows an object to look like its off the ground, and it collides with objects
// accordingly.
zOffset = 0;

// Stores any fraction values within the current hspd and vspd values. Prevent sub-pixel movement which
// would make collision checking/resolving a pain in the ass.
hspdFraction = 0;
vspdFraction = 0;

// Stores the true movement speed for the entity in the current frame, which is the difference in time between
// it and the previous frame. This allows for consistent movement speed without having to worry about changes
// in the frame rate, which is an erratic and rapidly changing value.
deltaHspd = 0;
deltaVspd = 0;

// Stores the current maximum possible horizontal and vertical velocities for the entity. These are different
// from their respective const variables so that these can be altered without ever losing the initial values.
maxHspd = 0;
maxVspd = 0;

// The CONSTANT value for the entity's maximum hspd and vspd, which cannot be adjusted by movement speed buffs
// and debuffs. However, they can be explicitly change if required through the set_max_move_speed method.
maxHspdConst = 0;
maxVspdConst = 0;

// An array and a flag that is used when an entity is being moved automatically using the "eneity_move_to_position"
// state. It stores the position they are moving to and the flag prevents the direction they are facing to be
// updating on a per-frame basis, which causes weird directional changes the closer the entity is to the target
// position.
targetPosition = [0, 0];
directionSet = false;

// Variables for the Footstep effects. The first stores the tilemap ID for the floor tiles; with Each floor 
// tile corresponding to a different sound effect for the entity's footstep. The next two variables are the
// frames of animation where the entity's right foot hits the ground, and their left foot hits the ground, 
// respectively. The final variable is the array of floor sounds to choose from; each index matching the 
// tile's index in the foorstep collision map.
collisionTilemap = -1;
rightFootIndex = -1;
leftFootIndex = -1;
footstepSounds = 0;
// Footstep sound indexes are ordered as follows:
//			0	=	Wood
//			1	=	Gravel
//			2	=	Concrete
//			3	=	Mud
//			4	=	Grass
//			5	=	Water
//			6	=	Snow

// A flag that prevents the footstep sounds from playing on every available in-game frame that a footstep 
// frame of the entity's animation is present. Resets on the next available frame to allow playback again.
playStepSound = false;

// The variables that keep track of the current hitpoints, maximum hitpoints, as well as damage resistance
// from attacks. The damage resistance is multiplied with recieved damage to calculte the total damage. A
// lower value results in lower damage taken. (1 = full damage, 0.6 = 60% damage taken)
hitpoints = 0;
maxHitpoints = 0;
damageResistance = 1;

// Variables for controlling the entity's health regeneration. The first value corresponds to the amount of
// hitpoints gained, and the last variable determines how many seconds of real-time need to pass before the
// entity gains said amount of health. Finally, the fraction variable store the fractional value for the
// amount of health regained. Once that value passes 1, the floored value will be gained as health and
// subtracted from the fraction value.
hpRegenAmount = 0;
hpRegenFraction = 0;
regenSpeed = 0;

// A flag that grants the entity temporary invincibility frames after getting hit by an enemy's attack.
// The time in frames (1 frame = 1/60 seconds) is variable and can be set to any amount of time. Also,
// an optional variable for locking the entity for a set section of invulnerability time.
isHit = false;
timeToRecover = 0;
recoveryTimer = 0;
stunLockTimer = 0;

// Two flags that determines whether or not the entity can take damage and be killed or if they have had
// their hitpoints reduced to 0; killing them at the start of the next frame.
isInvincible = false;
isDestroyed = false;

// A flag and variable for handling the animation system. Since all directions are contained within a single
// sprite resource, the animation end flag won't always trigger for looping animations in the middle of
// the sprite. The flag when true will call to the animation_end event for those cases specifically.
animationEnd = false;
localFrame = 0;

// Stores the values for the entity's current sprite. Namely, the total number of directions found in the
// spritesheet, the number of frames per direction that the the sprite contains, as well as the speed of 
// that sprite relative to the current frame's delta time.
sprDirections = 0;
sprFrames = 0;
sprSpeed = 0;

// The two default sprite variables that all entities have. It's like this way because of how cutscenes work,
// specifically the function that moves an entity to a given position during a scene, which uses the walking
// and standing sprites.
standSprite = -1;
walkSprite = -1;

// Two flags for drawing an entity's sprite. The first flag allows for a complete bypass of drawing an entity
// and the second allows for toggling the sprite animation on and off independent of any states.
drawSprite = true;
animateSprite = true;

// Variables that keep track of the entity's ambient light source. The first variable store the ID for the
// light that is attached to the current entity, and the vector below that keeps track of the position that
// the light will be in relative to the entity's current position each frame.
ambLight = noone;
lightPosition = [0, 0];

// A variable that keeps track of the audio emitter that can be attached to an entity. It can allow entities
// to play sound effects and have those sound effects placed properly in "3D" audio space; hopefully adding
// to the game's immersiveness.
audioEmitter = noone;
emitterPosition = [0, 0];

#endregion

// Adds the object to the grid for rendering using the depth sorting system.
ds_grid_resize(global.worldObjects, 2, ds_grid_height(global.worldObjects) + 1);