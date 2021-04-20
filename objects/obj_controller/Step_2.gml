/// @description Update Camera Position and Delta Time

// Update camera's position
camera_update_position();

// Set delta time for the current frame
global.deltaTime = (delta_time / 1000000) * global.targetFPS;