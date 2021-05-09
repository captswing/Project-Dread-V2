/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

image_speed = 0;
image_index = 0;
visible = false;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Variables that relate to the sound effect that is set for the emitter. The first variable stores the ID
// returned whenever the sound is played. The second stores the sound that the emitter actually plays, and
// the third is a flag that can be used to see if the emitter is playing its sound or not.
soundID = -1;
soundIndex = -1;
isSoundPlaying = false;

// Variables that relate to how the sound falls off relative to the distance of the game's audio listener.
// The first variable is the reference distance to begin falling off (0 sets it to silent). The second
// variable is the maximum distance that the sound can be heard from, and the last variable is how drastic
// the sound's dropoff is.
falloffRefDist = 100;
falloffMaxDist = 300;
falloffFactor = 1;

#endregion