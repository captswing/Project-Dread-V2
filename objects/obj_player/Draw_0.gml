/// @description Draw's the Player and Their Current Weapon

// Draw the player's sprite first and overlay the gun on top of it
event_inherited();

// Get the weapon sprite that will be drawn as an overlay onto the player's current sprite
curWeaponSprite = -1; // Always resets to -1 on a new frame
if (sprite_index == standSprite)		{curWeaponSprite = weaponStandSprite;}
else if (sprite_index == walkSprite)	{curWeaponSprite = weaponWalkSprite;}
else if (sprite_index == aimingSprite)	{curWeaponSprite = weaponAimSprite;}
// If the weapon sprite is valid, draw it overlayed onto the player's current sprite
if (curWeaponSprite != -1) {draw_sprite_ext(curWeaponSprite, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);}