shader_type spatial;
instance uniform float charge;

void fragment() {
	vec3 color;
	float middle = 0.5;

	if (abs(UV.x - middle) < charge / 2.0) {
		color = vec3(255, 255, 255);
	} else {
		color = vec3(0, 0, 0);
	}
	
	ALBEDO.rgb = color;
	EMISSION = color;
}
