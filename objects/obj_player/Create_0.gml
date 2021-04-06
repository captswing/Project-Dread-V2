/// @description Unique Variable Initialization/Editing Inherited Variables

#region SINGLETON CHECK

if (global.playerID != noone){
	if (global.playerID.object_index == object_index){
		instance_destroy(self);
		return;
	}
	instance_destroy(global.playerID);
}
global.playerID = id;

#endregion

#region EDITING INHERITED VARIABLES

// Initialize variables found in the parent's create event
event_inherited();
// Assign the player to their default state upon creation
set_cur_state(player_state_default);
// Sets the player's maximum hspd and vspd
entity_set_max_speed(1.25, 1.25, true);
// Create a dim light source so the player is semi-visible even in complete darkness
entity_create_light(0, -8, 15, 15, 0.1, c_ltgray, false);
// Assign the player's starting amount of hitpoints, which can be upgraded over time
maxHitpoints = 20;
hitpoints = maxHitpoints;
// Initialize the inherited sprite variables with claire's default sprites
standSprite = spr_claire_unarmed_stand;
walkSprite = spr_claire_unarmed_walk;

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
equipSlot = array_create(EquipSlot.Length, NO_ITEM);

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

// 
maxSanity = 100;
curSanity = maxSanity;
sanityModifier = 0;

// 
maxSanityTimer = 600;
sanityTimer = 0;

// 
effectTimers = ds_list_create();

// 
weaponSlot = -1;
damage = 0;
numBullets = 0;
range = 0;
accuracy = 0;
fireRate = 0;
reloadRate = 0;
bulletSpd = 0;
startFrame = 0;
endFrame = 0;

// 
damageMod = 0;
rangeMod = 0;
accuracyMod = 0;
fireRateMod = 0;
reloadRateMod = 0;

// 
ammoTypes = ds_list_create();
curAmmoType = 0;

// 
fireRateTimer = 0;
reloadTimer = 0;

// 
isLightActive = false;
lightSize = 0;
lightStrength = 0;
lightColor = c_white;

#endregion