shader_type spatial;
render_mode unshaded, cull_disabled;
varying vec3 normal;
varying vec3 world_normal;
varying vec3 world_position;
varying vec3 local_position;
varying vec3 pos_fract;
varying vec3 pos_fract_local;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	local_position = VERTEX;
	normal = normalize(abs(NORMAL));
	world_normal = normalize((MODEL_MATRIX * vec4(normal, 0.0)).xyz);
	pos_fract_local = normalize(fract(local_position * 0.999));
	pos_fract = normalize(fract(world_position));
}

void fragment() {
    vec4 view = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, FRAGCOORD.z, 1.0);
    view.xyz /= view.w;
    float depth_linear = -view.z;
	
	ALBEDO = vec3(
		world_normal.z * 0.45 + clamp(pos_fract_local.z,0.,0.999) * 0.45 + abs(world_normal.x * 0.1),
		world_normal.x * 0.5 + clamp(pos_fract_local.x,0.,0.999) * 0.5,
		depth_linear * 0.9 + clamp(pos_fract_local.y,0.,0.999) * 0.1
	);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
