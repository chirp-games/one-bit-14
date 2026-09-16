shader_type spatial;
render_mode unshaded, cull_disabled;
varying vec3 normal;
varying vec3 world_position;
varying vec3 pos_fract;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	normal = normalize(NORMAL);
	pos_fract = normalize(fract(world_position * 2.));
}

void fragment() {
    vec4 view = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, FRAGCOORD.z, 1.0);
    view.xyz /= view.w;
    float depth_linear = -view.z;
	
	float theta = atan(normal.x, normal.y);
	vec2 normal_2d = vec2(
		abs(normal.x * cos(2. * theta) + normal.y * cos(2. * theta)),
		normal.y * 0.75 + 0.25
	);
	
	ALBEDO = vec3(
		normal_2d.x * 0.5 + pos_fract.x * 0.5,
		normal_2d.y * 0.5 + pos_fract.y * 0.5,
		depth_linear
	);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
