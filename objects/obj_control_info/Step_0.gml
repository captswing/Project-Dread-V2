/// @description Shift the Color of the Background to Match its Target RGB Values

// 
for (var i = 0; i < 3; i++) {backgroundColorRGB[i] += (backgroundColorRGB[i + 3] - backgroundColorRGB[i]) / 5 * global.deltaTime;}
backgroundColor = make_color_rgb(backgroundColorRGB[0], backgroundColorRGB[1], backgroundColorRGB[2]);