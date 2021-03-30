/// @description Draw the Currently Active Textbox

var _data = [x, y, image_alpha];
with(ds_queue_head(textboxes)){
	draw_textbox(_data[0], _data[1], _data[2]);
}
draw_set_alpha(1);