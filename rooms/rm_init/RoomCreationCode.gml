// Initialize a new random seed on every start up to ensure randomness
randomize();

// Enable the GPU alpha test to discard transparent pixels in the render pipeline
gpu_set_alphatestenable(true);

// Sets the position of the audio listener that allows for audio to be perceived as 3-dimensional in the game.
audio_listener_orientation(0, -1, 0, 0, 0, -1);

// Load in the player's settings and initialize control icons
load_settings();
initialize_control_icons(false);

// All persistent, global objects will be created here
instance_create_depth(0, 0, GLOBAL_DEPTH, obj_controller);
instance_create_depth(0, 0, GLOBAL_DEPTH, obj_control_info);
instance_create_depth(0, 0, ENTITY_DEPTH, obj_depth_sorter);
instance_create_depth(0, 0, GLOBAL_DEPTH, obj_effect_handler);

// After intiialization, go to the next room and begin the game
room_goto_next();