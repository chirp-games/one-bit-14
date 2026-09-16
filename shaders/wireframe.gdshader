shader_type spatial;
render_mode diffuse_toon;
uniform sampler2D screen_texture: hint_screen_texture;
uniform float brightness: hint_range(0.0, 1.0) = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
	if (ALBEDO.r > ALBEDO.b) {
			ALBEDO = vec3(0.0);
		} else {
			ALBEDO = vec3(brightness);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
