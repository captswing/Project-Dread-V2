/// @description Unique Variable Initialization/Editing Inherited Variables

// Add the object as a singleton to prevent duplicates. If it fails, exit the create event early.
if (!add_singleton_object()) {return;}

#region EDITING INHERITED VARIABLES

// Initialize variables found in the parent's create event
event_inherited();
// Assign the player to their default state upon creation
set_cur_state(player_state_default);
// Sets the player's maximum hspd and vspd
entity_set_max_speed(1.1, 1.1, true);
// Create a dim light source so the player is semi-visible even in complete darkness
entity_create_light(0, -8, 15, 15, 0.1, c_ltgray, false, true);
// Assign the player's starting amount of hitpoints, which can be upgraded over time
maxHitpoints = 20;
hitpoints = maxHitpoints;
// The player will be allotted one second of invulnerability from attacks if they get hit
timeToRecover = 60;
// Initialize the inherited sprite variables with claire's default sprites
standSprite = spr_claire_unarmed_stand;
walkSprite = spr_claire_unarmed_walk;
// Setting up the player's footstep effect information
rightFootIndex = 0;
leftFootIndex = 2;
footstepSounds = [
	snd_player_step_wood,
	snd_player_step_gravel,
	snd_player_step_tile,
	snd_player_step_mud,
	snd_player_step_grass,
	snd_player_step_water,
	snd_player_step_snow
];

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Each of these variables represents a boolean value that relates to that keybinding's state, whether it's 
// being pressed in the current frame, held, or released by the player.
keyRight = false;
keyLeft = false;
keyUp = false;
keyDown = false;
keyRun = false;
keyReadyWeapon = false;
keyUseWeapon = false;
keyReload = false;
keyAmmoSwap = false;
keyFlashlight = false;
keyInteract = false;
keyPause = false;
keyItems = false;
keyNotes = false;
keyMaps = false;

// A 2D vector that stores the x and y positions for the player's interaction point, which is a position
// that is around 8 pixels in front of whatever direction that player's sprite is currently facing.
interactOffset = [0, 0];

// These variables correspond with a sprite/animation for the player during the task specified within the
// variables name. This allows for easy hot-swapping of sprites based on current equipped weapon and things
// like that without much code needed for updating the player's current sprite to meet those demands.
aimingSprite = -1;
reloadSprite = -1;
recoilSprite = -1;

// Variables that allow movement to actually work. The first one stores the direction of the movement based
// on what combination of right/left and up/down keys have been pressed. Meanwhile, the second variable stores
// how fast the player will move relative to the calculated input direction. It basically provides accurate
// movement speeds in all possible directions.
inputDirection = 0;
inputMagnitude = 0;

// An array that stores what is currently equipped in each of the player's "equipment" slots. The only slots
// that can have more than one specific item in them are the amulet slots, which can have any combination of
// two out of the eight amulets, and current weapon slot, which holds the name for whatever weapon is currently
// equipped. Otherwise, the armor slot is specifically for the Kevlar Vest item, and the flashlight slot is 
// specifically for the flashlight item.
equipSlot = array_create(EquipSlot.Length, -1);

// Two flags that determine if the player character current has either the poisoned or bleeding status. Both
// of these status conditions use the same timer, but the poison's damage is every other check. This means
// that bleeding damage occurs every 2.5 seconds, and poison damage is every 5 seconds.
isPoisoned = false;
isBleeding = false;

// The timer that checks for dealing out both poison and bleeding damage. The poison damage occurs every 
// other check resulting from this timer, and the bleeding damage will be dished out every check.
maxConditionTimer = 150;
conditionTimer = 0;

// Two variables that handle how the poison status condition differs from the bleeding status effect. The 
// flag allows poison to deal damage on every other condition check, while the poison's current damage for
// that check is held in the second variable. This damage is doubled every time damage is dealt until it
// reaches 100% hitpoint damage.
dealPoisonDamage = false;
curPoisonDamage = 0.01;

// The three variables that handle the player's current sanity levels. It contains a maximum value, (can be
// increased or decreased through different means) a current value, (which corresponds to hallucinations and
// other negative effects when too low) and the modifier value, which is what adjusts the current value by
// adding or subtracting its value to it.
maxSanity = 100;
curSanity = maxSanity;
sanityModifier = 0;

// The timer variables for the player's sanity. Every 10 seconds of in-game time, (60 = 1 second) the game
// will add the player's sanity modifier to their current sanity level, which allows it to be increased or
// decreased in very little code.
maxSanityTimer = 600;
sanityTimer = 0;

// A list of arrays that contain data about effects that are currently being applied onto the player. They
// can be either an indefinite effect, which is only removed through code that actually removes it from the
// list, or it can be remove automatically over a set amount of time given to the effect.
//
//		effectTimers[i]	= [effectID, timeRemaining, startFunction, endFunction]
//
effectTimers = ds_list_create();

// All these variables are used to store the currently equipped weapon's stats. They include the slot it's
// contained in, the number of bullets fired from the weapon, the base damage, range, accruacy, fire rate, 
// and reload rate. Also, the speed of the bullet can be set, (which enables a physical projectile instead of
// a hitscan check) or the starting/ending frames of animation for an attack can be set. (which is used for
// the active frames of a melee attack)
damage = 0;
numBullets = 0;
range = 0;
accuracy = 0;
fireRate = 0;
reloadRate = 0;
bulletSpd = 0;
startFrame = 0;
endFrame = 0;

// Five modifier values for their corresponding stats. They aren't multiplied onto the base values, but are
// added or subtracted from the value depending on the modifier value. Each ammunition type for the current
// weapon will modifier these values in some way.
damageMod = 0;
rangeMod = 0;
accuracyMod = 0;
fireRateMod = 0;
reloadRateMod = 0;

// A multiplier for the weapon's damage, which is only ever altered by items like the Power Amulet and items
// that grant temporary damage boosts; if those ever become a thing...
damageMultiplier = 1;

// Each of these variables contains a sound effect that will play for performing a given action when using 
// the currently equipped weapon.
weaponUseSound = -1;
weaponReloadSound = -1;

// 
curWeaponSprite = -1;
weaponStandSprite = -1;
weaponWalkSprite = -1;
weaponAimSprite = -1;

// Stores all of the possible types of ammunition that can be accepted by the currently equipped weapon. The
// ammunition has the ability to alter the base stats of the weapon; improving things like damage, reload
// speed, fire rate, range, and even accuracy.
ammoTypes = -1;

// Stores the current ammo that the player is holding in each of the unique weapon's in the game that consume
// ammunition. This is to ensure that the inventory doesn't need to store data for the weapon's ammunition,
// and that the correct ammunition will always be in the gun regardless of if they unequipped it.
curAmmoType = ds_map_create();
ds_map_add(curAmmoType, HANDGUN,			0);
ds_map_add(curAmmoType, PUMP_SHOTGUN,		0);
ds_map_add(curAmmoType, HUNTING_RIFLE,		0);
ds_map_add(curAmmoType, SUBMACHINE_GUN,		0);
ds_map_add(curAmmoType, HAND_CANNON,		0);
ds_map_add(curAmmoType, GRENADE_LAUNCHER,	0);

// Stores the penalty that is applied to the weapon's accuracy when the player is firing their equipped gun.
// It increments by a set amount for each bullet fired, and the amount is unique to each weapon. For example,
// the standard pistol only has a 0.5 accuracy penalty; meanwhile the hand cannon has a 2.5 accuracy penalty.
accuracyPenalty = 0;

// Two timers that control how long the player is stuck within the reloading and recoiling state, respectively.
// One second of real-time is equal to a value of 60 in these timers, sine that is the game's targeted frame 
// rate.
fireRateTimer = 0;
reloadTimer = 0;

// These variables allow the player's ambient light source (which is small and dim by default) to be altered
// in size by the player toggling their flashlight on or off. The stronger flashlight will make these values
// much greater than the standard flashlight.
isLightActive = false;
lightSize = 0;
lightStrength = 0;
lightColor = c_white;

// 
pushDirection = 0;
pushedObjectID = noone;
pushedObjectWeight = 1;

// 
pushAnimateTimer = 0;
pushAnimateTime = 20;

#endregion

// FOR TESTING
inventory_add(FLASHLIGHT, 1, 0);
inventory_add(HANDGUN, 7, 60);
inventory_add(HANDGUN_AMMO_PLUS, 35, 0);
inventory_add(KEVLAR_VEST, 1, 0);
inventory_add(TOUGHNESS_AMULET, 1, 0);
inventory_add(IMMUNITY_AMULET, 1, 0);

player_equip_item(0);
player_equip_item(1);
//player_equip_item(3);
player_equip_item(4);
player_equip_item(5);

inventory_swap(1, 5);