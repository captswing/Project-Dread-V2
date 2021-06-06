/// @description 
/// @param infoInactiveText
function menu_option_info_set_inactive_text(_infoInactiveText){
	infoInactiveText = string_split_lines(_infoInactiveText, infoMaxWidth, infoFont);
	infoInactiveTextLength = string_length(_infoInactiveText);
}