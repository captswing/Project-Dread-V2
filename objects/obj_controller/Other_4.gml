/// @description Enable the Current Room's View/Update Entity Stuff/Disable Visibility of Colliders

if (cameraID != -1){ // Only enable the view if a valid camera object exists
	view_enabled = true;
	view_camera[0] = cameraID;
	view_set_visible(0, true);
}

// Gets the footstep sound tile layer for the current room
with(par_dynamic_entity) {collisionTilemap = layer_tilemap_get_id(layer_get_id("Footstep_Tiles"));}

// Disable visibility of collision layer if debug mode isn't enabled
var _isVisible = showDebugInfo;
with(obj_collider_solid) {visible = _isVisible;}