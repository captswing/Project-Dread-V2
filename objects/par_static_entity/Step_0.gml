/// @description Calling Current State Function/Executing General Code

// If no state is prepared for the entity to execute, the entity itself will not function
if (curState == NO_STATE){
	return;
}

// Execute the method containing the current state's code.
script_execute(curState);