/// @description Drawing In-Game HUD

#region DRAWING THE IN-GAME HUD ELEMENTS

// Everything below these two lines should be used to display text onto the in-game HUD
shader_set(outlineShader);
shader_set_uniform_i(sDrawOutline, 1);

// If the accessibility setting is toggled to show a control prompt for interacting with objects, this code
// to check if the player's interaction point is on an interactable in order to show the control prompt.
if (global.settings[Settings.InteractionPrompt]){
	// Setting the color of the interaction prompt, and the font used for said prompt
	draw_set_color(c_white);
	shader_set_uniform_f_array(sOutlineColor, [0.5, 0.5, 0.5]);
	outline_set_font(font_gui_small, global.fontTextures[? font_gui_small], sPixelWidth, sPixelHeight);
	// Jump over to the player object and checks the interaction point for a collision with an interactable
	// object. If an interactable exists at that point, display the prompt.
	with(global.singletonID[? PLAYER]){
		if (curState == player_state_default){ // Don't show the interaction prompt if the player isn't in their default state
			var _interactOffset = [interactOffset[X], interactOffset[Y]];
			with(instance_nearest(x, y, par_interactable)){ // Jump over to the nearest interactable to see if the player can interact
				if (canInteract && point_distance(_interactOffset[X], _interactOffset[Y], interactCenter[X], interactCenter[Y]) <= interactRadius){
					// Get the offset for the sprite based off the center of the screen to correctly position the sprite and text
					var _controlIcon, _spriteWidth, _stringWidth, _promptPosition;
					_controlIcon = global.controlIcons[? ICON_SELECT];
					_spriteWidth = sprite_get_width(_controlIcon[0]) + 3;
					_stringWidth = string_width(interactionText) + 2;
					_promptPosition = (WINDOW_WIDTH / 2) - ((_spriteWidth + _stringWidth) / 2);
					draw_text(_promptPosition + _spriteWidth, WINDOW_HEIGHT - 30, interactionText);
					shader_reset(); // Prevent an outline from surrounding the prompt's sprite
					draw_sprite(_controlIcon[0], _controlIcon[1], _promptPosition, WINDOW_HEIGHT - 32);
				}
			}
		}
	}
}

// Resets the shaders if it wasn't reset by the interaction prompt above
if (shader_current() == outlineShader) {shader_reset();}

#endregion

#region DRAWING ALL OTHER GUI ELEMENTS AFTER THE IN-GAME HUD

// Loop through each object in the entity list and execute their draw GUI event
var _screenX, _screenY, _screenW, _screenH, _length;
_screenX = x - (WINDOW_WIDTH / 2);
_screenY = y - (WINDOW_HEIGHT / 2);
_screenW = _screenX + WINDOW_WIDTH;
_screenH = _screenY + WINDOW_HEIGHT;
_length = ds_grid_height(global.worldObjects);
for (var i = 0; i < _length; i++){
	with(global.worldObjects[# 0, i]){
		if (!drawSprite || x <= _screenX - sprite_width || x >= _screenW + sprite_width || y <= _screenY - sprite_height || y >= _screenH + sprite_height){
			continue;	// The object isn't currently on screen or isn't supposed to be drawn
		}
		event_perform(ev_draw, ev_gui);
	}
}

// Display the textbox after any HUD drawing
with(global.singletonID[? TEXTBOX]) {event_perform(ev_draw, ev_gui);}

// Finally, display the current control information to the screen
with(global.singletonID[? CONTROL_INFO]) {event_perform(ev_draw, ev_gui);}

#endregion

// DEBUGGING STUFF BELOW HERE (WILL BE DELETED EVENTUALLY)

shader_set(outlineShader);
shader_set_uniform_i(sDrawOutline, 1);

draw_set_color(c_white);
shader_set_uniform_f_array(sOutlineColor, [0.5, 0.5, 0.5]);
outline_set_font(font_gui_small, global.fontTextures[? font_gui_small], sPixelWidth, sPixelHeight);

if (showItems){ // Showing the player's current inventory
	draw_set_halign(fa_right);
	draw_text(WINDOW_WIDTH - 5, 5, "-- Inventory Data --");
	for(var i = 0; i < global.invSize; i++){
		draw_text(WINDOW_WIDTH - 5, 15 + (i * 10), global.invItem[i][0] + " x" + string(global.invItem[i][1]));
	}
	draw_set_halign(fa_left);
}

if (!showDebugInfo){
	shader_reset();
	return;
}

draw_set_alpha(1);
draw_text(5, 5, "In-Game Playtime:\nDelta Time:\nRoom Size:\nInstances:\nDynamic Entities:\nStatic Entities:\nEntities Drawn:\nLights Drawn:\n\n-- Camera Data --\nPosition:\nFollowing:\n\n-- Player Data --\nCurrent State:\nLast State:\nPosition:\nMax Speed:\nHitpoints:\nCurrent Sanity:\nSanity Modifier:");

// Getting the number of objects drawn by the depth sorter
var _totalObjectsDrawn = 0;
with(global.singletonID[? DEPTH_SORTER]) {_totalObjectsDrawn = totalObjectsDrawn;}

// Getting the number of lights drawn by the lighting shader
var _totalLightsDrawn = 0;
with(global.singletonID[? EFFECT_HANDLER]) {_totalLightsDrawn = lightsDrawn;}

// Getting the camera's followed object's index
var _objectIndex = noone;
with(curObject) {_objectIndex = object_index;}

// Getting player information for the debug HUD
var _x, _y, _maxHspd, _maxVspd, _hitpoints, _maxHitpoints, _sanity, _maxSanity, _sanityModifier, _curState, _lastState, _baseSanityMod;
_x = 0;
_y = 0;
_maxHspd = 0;
_maxVspd = 0;
_hitpoints = 0;
_maxHitpoints = 0;
_sanity = 0;
_maxSanity = 0;
_sanityModifier = 0;
_curState = 0;
_lastState = 0;
_baseSanityMod = global.isRoomSafe ? SANITY_MOD_SAFE : SANITY_MOD_UNSAFE;
with(global.singletonID[? PLAYER]){
	_x = x;
	_y = y;
	
	_maxHspd = maxHspd;
	_maxVspd = maxVspd;
	
	_hitpoints = hitpoints;
	_maxHitpoints = maxHitpoints;
	
	_sanity = curSanity;
	_maxSanity = maxSanity;
	_sanityModifier = sanityModifier;
	
	_curState = curState;
	_lastState = lastState;
}

shader_set_uniform_f_array(sOutlineColor, [0.5, 0, 0]);
draw_set_halign(fa_right);
draw_set_color(c_red);
draw_text(136, 5, global.playtimeString + "\n" +
				  string(global.deltaTime) + "\n" +
				  "[" + string(room_width) + ", " + string(room_height) + "]\n" + 
				  string(instance_number(all)) + "\n" + 
				  string(instance_number(par_dynamic_entity)) + "\n" +
				  string(instance_number(par_static_entity)) + "\n" +
				  string(_totalObjectsDrawn) + "\n" +
				  string(_totalLightsDrawn) + "\n\n\n" +
				  "[" + string(x) + ", " + string(y) + "]\n" +
				  object_get_name(_objectIndex) + "\n\n\n\n\n" +
				  "[" + string(_x) + ", " + string(_y) + "]\n" + 
				  "[" + string(_maxHspd) + ", " + string(_maxVspd) + "]\n" +
				  string(_hitpoints) + "/" + string(_maxHitpoints) + "\n" +
				  string(_sanity) + "/" + string(_maxSanity) + "\n" +
				  string(_baseSanityMod + _sanityModifier));

draw_set_halign(fa_left);
draw_text(70, 5, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n" + 
				  script_get_name(_curState) + "\n" +
				  script_get_name(_lastState));

shader_reset();