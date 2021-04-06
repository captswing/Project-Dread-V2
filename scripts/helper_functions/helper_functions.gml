/// @description Swaps the current active game state to another based on the argument provided. If the high
/// priority flag is not toggled, the game state won't be set if it falls below the priority of the current
/// state. Otherwise, it will overwrite regardless of the state. Finally, the previous state will be stored
/// in the previous game state variable.
/// @param newState
/// @param highPriority
function set_game_state(_newState, _highPriority){
	if (_newState == global.gameState || _newState < GameState.InGame || _newState > GameState.Paused){
		return; // An invalid OR the same game state was provided, don't change game states
	}
	// Toggling the high priority flag allows the game state to overwrite a more prioritized state. The order
	// of priority in the states is as follows: in-game, in-menu, cutscene, and finally paused.
	if (_highPriority || global.gameState < _newState){
		global.prevGameState = global.gameState;
		global.gameState = _newState;
	}
}