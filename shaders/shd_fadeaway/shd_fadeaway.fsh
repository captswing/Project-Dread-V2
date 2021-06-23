//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vPosition;

uniform vec2 screenSize;
uniform vec2 threshold;
uniform vec2 fadeCutoff;

void main() {
	vec4 baseColor = texture2D( gm_BaseTexture, v_vTexcoord );
	// All the calculations are based on the texture's base alpha values, and not a value of 1 explicitly
	float alpha = baseColor.a;
	// Fading away on the x-axis
	if (v_vPosition.x >= threshold.x){
		if (v_vPosition.x > fadeCutoff.x) {alpha = 0.0;}
		else {alpha *= (fadeCutoff.x - v_vPosition.x) / (fadeCutoff.x - threshold.x);}
	}
	// Fading away on the y-axis
	if (v_vPosition.y >= threshold.y){
		if (v_vPosition.y > fadeCutoff.y) {alpha = 0.0;}
		else {alpha *= (fadeCutoff.y - v_vPosition.y) / (fadeCutoff.y - threshold.y);}
	}
	
    gl_FragColor = v_vColour * vec4(baseColor.rgb, alpha);
}
