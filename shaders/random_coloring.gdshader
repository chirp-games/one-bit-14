shader_type spatial;
render_mode unshaded, cull_disabled;
varying vec3 normal;
varying vec3 world_normal;
varying vec3 local_position;
varying vec3 world_position;
varying vec3 pos_fract;
varying vec3 pos_fract_world;

void vertex() {
	local_position = VERTEX;
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	normal = normalize(abs(NORMAL));
	world_normal = normalize((MODEL_MATRIX * vec4(normal, 0.0)).xyz);
	pos_fract = fract(local_position * 0.01);
	pos_fract_world = fract(world_position * 10.);
}

void fragment() {
    vec4 view = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, FRAGCOORD.z, 1.0);
    view.xyz /= view.w;
    float depth_linear = -view.z;
	
	ALBEDO = vec3(
		abs(world_normal.z) * 0.5 * clamp(local_position.y,0.1,0.99) + pos_fract.x * 0.25 + pos_fract.y * 0.25,
		abs(world_normal.y) * 0.5 + pos_fract.x * 0.25 + pos_fract.z * 0.25,
		abs(world_normal.x) * 0.5 * clamp(local_position.y,0.1,0.99) + depth_linear
	);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
