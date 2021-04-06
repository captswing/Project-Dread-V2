/// @description Enumerators used by the game's various systems.

// Stores the state of the game on a global scale at the given moment.
enum GameState{
	NoState,
	InGame,
	InMenu,
	Cutscene,
	Paused,
}

// Stores the values that correspond to the game's overall difficulty level, which effect damage dealt and
// taken, how the save system functions, health regeneration, and so on. However, puzzle difficulty is not
// affected by this difficulty level.
enum Difficulty{
	NotSelected,
	Forgiving,
	Standard,
	Punishing, 
	Nightmare,		// Locked until game is completed on "Punishing" difficulty
	OneLifeMode,	// Locked until game is completed on "Nightmare" difficulty with at least an A rank
}

// Stores the values that correspond to the game's overall puzzle difficulty, which will make each puzzle
// either simpler or harder depending on what value is selected by the user.
enum PuzzleDifficulty{
	NotSelected,
	Forgiving,
	Standard,
	Punishing,
}

// An enumerator for storing the array indexes for each respective game setting.
enum Settings{
	// Video Settings //
	ResolutionScale,
	FullScreen,
	Brightness,
	Contrast,
	Saturation,
	Gamma,
	Bloom,
	Aberration,
	Scanlines,
	FilmGrain,
	// Audio Settings //
	Master,
	Sounds,
	Music,
	EnableMusic,
	// Keyboard Settings //
	GameRight,		// In-Game Controls (Keyboard)
	GameLeft,
	GameUp,
	GameDown,
	Run,
	ReadyWeapon,
	UseWeapon,
	Reload,
	AmmoSwap,
	Flashlight,
	Interact,
	Items,
	Maps,
	Notes,
	Pause,
	MenuDown,		// Menu Controls (Keyboard)
	MenuUp,
	MenuLeft,
	MenuRight,
	Select,
	Return,
	FileDelete,
	// Gamepad Settings //
	GameRightGP,	// In-Game Controls (Gamepad)
	GameLeftGP,
	GameUpGP,
	GameDownGP,
	RunGP,
	ReadyWeaponGP,
	UseWeaponGP,
	ReloadGP,
	AmmoSwapGP,
	FlashlightGP,
	InteractGP,
	ItemsGP,
	MapsGP,
	NotesGP,
	PauseGP,
	MenuDownGP,		// Menu Controls (Gamepad)
	MenuUpGP,
	MenuLeftGP,
	MenuRightGP,
	SelectGP,
	ReturnGP,
	FileDeleteGP,
	// Accessibility Settings //
	TextSpeed,
	ObjectiveHints,
	ItemHighlighting,
	AimAssist,
	// Holds Total Number of Settings //
	Length,
}

// An enumerator for the actor IDs associated with each character
enum Actor{
	None,		// No valid actor index
	Claire		// The main protagonist
}

// An enumerator that holds the indexes for the various weather effects that can be toggled in-game
enum Weather{
	Clear,
	Rain,
	Mist,
}

// An enumerator that holds the indexes for the character's equipment slot array
enum EquipSlot{
	Weapon,
	Flashlight,
	Armor,
	AmuletOne,
	AmuletTwo,
	// Holds the Total Number of Equipment Slots //
	Length,
}

// An enumerator that holds the values for each of the possible temporary/indefinite effects that can be applied onto the player.
enum Effect{
	BleedImmunity,
	PoisonImmunity,
	DamageResist,
}