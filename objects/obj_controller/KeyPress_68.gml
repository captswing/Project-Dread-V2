/// @description Toggle Debug Info On/Off

showDebugInfo = !showDebugInfo;
//show_debug_overlay(showDebugInfo);
// Enabling and disabling certain tile layers and objects depending on the debug state
var _isVisible = showDebugInfo;
with(obj_collider_solid) {visible = _isVisible;}