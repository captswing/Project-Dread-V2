/// @description Stores all of the macro values referenced throughout the code.

// Global object depth and entity depth
#macro	GLOBAL_DEPTH				5
#macro	ENTITY_DEPTH				200

// In-game tile width/height in pixels
#macro	TILE_SIZE					16

// The width and height of the game's window
#macro	WINDOW_WIDTH				320
#macro	WINDOW_HEIGHT				180

// The name for the settings ini file
#macro	SETTINGS_FILE				"settings.ini"
#macro	SAVE_FILE_EXT				".data"

// Stores the value that when converted equals "99:59:59"
#macro	MAX_TIME_VALUE				35999999

// Represents a value that means no functional state/script exists
#macro	NO_STATE				   -1
#macro	NO_SCRIPT				   -1

// Vector array indexes
#macro	X							0
#macro	Y							1

// Animation constants
#macro	ANIMATION_FPS				60

// Inventory constants
#macro	MAX_INV_SIZE				24

// The standard values for sanity modification
#macro	SANITY_MOD_UNSAFE		   -1
#macro	SANITY_MOD_SAFE				1

// Value for an effect with an indefinite duration
#macro	INDEFINITE_EFFECT		   -127

// GUI animation constants
#macro	BACKWARD_ANIMATE		   -1
#macro	NO_ANIMATE					0
#macro	FORWARD_ANIMATE				1

// Inventory item option values
#macro	USE_ITEM					"Use"
#macro	EQUIP_ITEM					"Equip"
#macro	UNEQUIP_ITEM				"Unequip"
#macro	RELOAD_ITEM					"Reload"
#macro	COMBINE_ITEM				"Combine"
#macro	MOVE_ITEM					"Move"
#macro	DROP_ITEM					"Drop"

// Item data map values
#macro	ITEM_LIST					"Item List"
#macro	CRAFTING_DATA				"Crafting Data"
#macro	WEAPON_DATA					"Weapon Data"
#macro	AMMO_DATA					"Ammo Data"
#macro	CONSUMABLE_DATA				"Consumable Data"

// Item list map values
#macro	ITEM_TYPE					"Type"
#macro	EQUIPMENT_TYPE				"Equipment Type"
#macro	DESCRIPTION					"Description"
#macro	MAX_STACK					"Max Stack"

// Item type map values
#macro	WEAPON						"Weapon"
#macro	WEAPON_INF					"Weapon (Inf)"
#macro	CONSUMABLE					"Consumable"
#macro	COMBINABLE					"Combinable"
#macro	AMMUNITION					"Ammunition"
#macro	KEY_ITEM					"Key Item"
#macro	ARMOR						"Armor"
#macro	LIGHT_SOURCE				"Light Source"
#macro	AMULET						"Amulet"

// Crafting data map values
#macro	VALID_ITEMS					"Valid Items"
#macro	RESULT_ITEMS				"Result Items"
#macro	MIN_CRAFTED					"Min Crafted"
#macro	MAX_CRAFTED					"Max Crafted"

// Weapon data map values
#macro	DAMAGE						"Damage"
#macro	NUM_BULLETS					"No. Bullets"
#macro	ACCURACY					"Accuracy"
#macro	RANGE						"Range"
#macro	FIRE_RATE					"Fire Rate"
#macro	RELOAD_RATE					"Reload Rate"
#macro	DURABILITY					"Durability"
#macro	START_FRAME					"Start Frame"
#macro	END_FRAME					"End Frame"
#macro	BULLET_SPEED				"Speed"
#macro	AMMO_TYPES					"Ammo Types"

// Ammo data map values
#macro	DAMAGE_MOD					"Dmg Mod"
#macro	ACCURACY_MOD				"Acc Mod"
#macro	RANGE_MOD					"Range Mod"
#macro	FIRE_RATE_MOD				"FRate Mod"
#macro	RELOAD_RATE_MOD				"RRate Mod"

// World item data map values
#macro	NAME						"Name"
#macro	QUANTITY					"Quantity"
#macro	X_POSITION					"X"
#macro	Y_POSITION					"Y"
#macro	ROOM						"Room"

// Item name map values
#macro	NO_ITEM						"---"
#macro	HANDGUN						"9mm Handgun"
#macro	PUMP_SHOTGUN				"Pump Shotgun"
#macro	HUNTING_RIFLE				"Hunting Rifle"
#macro	SUBMACHINE_GUN				"Submachine Gun"
#macro	HAND_CANNON					"Hand Cannon"
#macro	GRENADE_LAUNCHER			"Grenade Launcher"
#macro	POCKET_KNIFE				"Pocket Knife"
#macro	STEEL_PIPE					"Steel Pipe"
#macro	FIRE_AXE					"Fire Axe"
#macro	CHAINSAW					"Chainsaw"
#macro	SHARP_POCKET_KNIFE			"Sharp Pocket Knife"
#macro	REINFORCED_PIPE				"Reinforced Pipe"
#macro	HEAVY_FIRE_AXE				"Heavy Fire Axe"
#macro	INF_HANDGUN					"Inf. 9mm Handgun"
#macro	INF_SUBMACHINE_GUN			"Inf. Submachine Gun"
#macro	INF_NAPALM_LAUNCHER			"Inf. Napalm Launcher"
#macro	INF_CHAINSAW				"Inf. Chainsaw"
#macro	HANDGUN_AMMO				"Handgun Ammo"
#macro	HANDGUN_AMMO_PLUS			"Handgun Ammo+"
#macro	SHOTGUN_SHELLS				"Shotgun Shells"
#macro	SHOTGUN_SHELLS_PLUS			"Shotgun Shells+"
#macro	RIFLE_ROUNDS				"Rifle Rounds"
#macro	RIFLE_ROUNDS_PLUS			"Rifle Rounds+"
#macro	SMG_AMMO					"SMG Ammo"
#macro	SMG_AMMO_PLUS				"SMG Ammo+"
#macro	MAGNUM_ROUNDS				"Magnum Rounds"
#macro	MAGNUM_ROUNDS_PLUS			"Magnum Rounds+"
#macro	EXPLOSIVE_SHELLS			"Explosive Shells"
#macro	EXPLOSIVE_SHELLS_PLUS		"Explosive Shells+"
#macro	FRAGMENT_ROUNDS				"Fragment Rounds"
#macro	NAPALM_ROUNDS				"Napalm Rounds"
#macro	FROST_ROUNDS				"Frost Rounds"
#macro	FUEL						"Fuel"
#macro	REFINED_FUEL				"Refined Fuel"
#macro	PURIFIED_FUEL				"Purified Fuel"
#macro	BLUE_ANTISEPTIC				"Blue Antiseptic"
#macro	PURPLE_ANTISEPTIC			"Purple Antiseptic"
#macro	YELLOW_ANTIYSEPTIC			"Yellow Antiseptic"
#macro	MIXED_ANTISEPTIC_BB			"Mixed Antiseptic (B+B)"
#macro	MIXED_ANTISEPTIC_BBB		"Mixed Antiseptic (B+B+B)"
#macro	MIXED_ANTISEPTIC_BP			"Mixed Antiseptic (B+P)"
#macro	MIXED_ANTISEPTIC_BPP		"Mixed Antiseptic (B+P+P)"
#macro	MIXED_ANTISEPTIC_BY			"Mixed Antiseptic (B+Y)"
#macro	MIXED_ANTISEPTIC_BYY		"Mixed Antiseptic (B+Y+Y)"
#macro	MIXED_ANTISEPTIC_BPY		"Mixed Antiseptic (B+P+Y)"
#macro	MIXED_ANTISEPTIC_PP			"Mixed Antiseptic (P+P)"
#macro	MIXED_ANTISEPTIC_PY			"Mixed Antiseptic (P+Y)"
#macro	MIXED_ANTISEPTIC_PPY		"Mixed Antiseptic (P+P+Y)"
#macro	MIXED_ANTISEPTIC_PYY		"Mixed Antiseptic (P+Y+Y)"
#macro	MIXED_ANTISEPTIC_YY			"Mixed Antiseptic (Y+Y)"
#macro	FIRST_AID_KIT_SMALL			"First Aid Kit (Small)"
#macro	FIRST_AID_KIT_LARGE			"First Aid Kit (Large)"
#macro	REVITALIFE					"Revitalife"
#macro	ITEM_POUCH					"Item Pouch"
#macro	GUNPOWDER					"Gunpowder"
#macro	GUNPOWDER_PLUS				"Gunpowder+"
#macro	FINE_GUNPOWDER				"Fine Gunpowder"
#macro	FINE_GUNPOWDER_PLUS			"Fine Gunpowder+"
#macro	ENHANCED_GUNPOWDER			"Enhanced Gunpowder"
#macro	ENHANCED_GUNPOWDER_PLUS		"Enhanced Gunpowder+"
#macro	EMPTY_CASINGS_SMALL			"Empty Casings (Small)"
#macro	EMPTY_CASINGS_MEDIUM		"Empty Casings (Medium)"
#macro	EMPTY_CASINGS_LARGE			"Empty Casings (Large)"
#macro	SCRAP						"Scrap"
#macro	REFINED_SCRAP				"Refined Scrap"
#macro	UPGRADE_PARTS				"Upgrade Parts"
#macro	FLASHLIGHT					"Flashlight"
#macro	BRIGHT_FLASHLIGHT			"Bright Flashlight"
#macro	KEVLAR_VEST					"Kevlar Vest"
#macro	HARDENED_KEVLAR_VEST		"Hardened Kevlar Vest"
#macro	FORTIFIED_AMULET			"Fortified Amulet"
#macro	IMMUNITY_AMULET				"Immunity Amulet"
#macro	POWER_AMULET				"Power Amulet"
#macro	HEALING_AMULET				"Healing Amulet"
#macro	LUCKY_AMULET				"Lucky Amulet"
#macro	TOUGHNESS_AMULET			"Toughness Amulet"
#macro	REFUND_AMULET				"Refund Amulet"
#macro	CALMING_AMULET				"Calming Amulet"
#macro	SPARE_PARTS					"Spare Parts"
#macro	SPARE_PARTS_PLUS			"Spare Parts+"

// Overall dialogue data map values
#macro	DIALOGUE_DATA				"Dialogue Data"
#macro	ACTOR_DATA					"Actor Data"

// Dialogue map values
#macro	END_DIALOGUE				"END"
#macro	NEXT_ID						"Next ID"
#macro	ACTOR						"Actor"
#macro	DIALOGUE					"Dialogue"

// Actor map values
#macro	LAST_NAME					"Last Name"
#macro	NAME_COLOR					"Name Color"
#macro	BACK_COLOR					"Back Color"
#macro	PORTRAIT_ID					"Portrait ID"

// Dialogue ID map values
#macro	TEST_DIALOGUE				"0"

// Actor name map values
#macro	NO_ACTOR					"NoActor"
#macro	CLAIRE						"Claire"