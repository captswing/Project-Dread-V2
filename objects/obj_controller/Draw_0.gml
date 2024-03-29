/// @description Weather Effects/Debug Stuff

// DEBUGGING STUFF BELOW HERE (WILL BE DELETED EVENTUALLY)

// Drawing collision boxes for entities
if (!showDebugInfo){
	return;
}

draw_set_alpha(1);

// Dynamic entity collision areas
with(par_dynamic_entity){
	switch(object_index){
		case obj_player:
			draw_rect_outline(bbox_left, bbox_top, 1 + (bbox_right - bbox_left), 1 + (bbox_bottom - bbox_top), c_gray, c_gray, 0.5, 1);
			// Also, draw the player's interaction point
			draw_set_alpha(0.5);
			draw_point_color(interactOffset[X], interactOffset[Y], c_white);
			break;
	}
}
// Static entity collision areas
with(par_static_entity){
	if (object_get_parent(object_index) == par_interactable){
		draw_set_alpha(0.5);
		draw_circle_color(interactCenter[X] - 1, interactCenter[Y] - 1, interactRadius, c_lime, c_green, false);
	} else{
		draw_rect_outline(bbox_left, bbox_top, 1 + (bbox_right - bbox_left), 1 + (bbox_bottom - bbox_top), c_gray, c_gray, 0.5, 1);
	}
}