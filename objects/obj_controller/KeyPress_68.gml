/// @description Toggle Debug Info On/Off

showDebugInfo = !showDebugInfo;
// Enabling and disabling certain tile layers and objects depending on the debug state
layer_set_visible("Collision", showDebugInfo);