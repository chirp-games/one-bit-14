shader_type spatial;
instance uniform float black_hole_distance;

void fragment() {
	vec3 color;
	if (UV.x > 1.0 - black_hole_distance) {
		color = vec3(255, 255, 255);
	} else {
		color = vec3(0, 0, 0);
	}
	
	ALBEDO.rgb = color;
	EMISSION = color;
}
