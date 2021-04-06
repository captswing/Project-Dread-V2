/// @description Clean Up Data Structures/Unfreezing Player Input

// Removes the queue data structure from memory
ds_queue_destroy(sceneData);

// Return the game state back to InGame
global.gameState = GameState.InGame;