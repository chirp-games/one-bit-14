shader_type spatial;

render_mode unshaded,blend_mix,depth_prepass_alpha,cull_disabled,specular_disabled;

uniform sampler2D sprite_texture : source_color, filter_linear;

void fragment() {
	vec2 pixel_size = 1.0 / vec2(textureSize(sprite_texture, 0));

	float pos = abs(length(UV.xy - .5));
	float ring_size = float(.001);
	
	if (pos < .45 + ring_size && pos > .45 - ring_size) {
		ALPHA = 1.0;
	} else {
		ALPHA = 0.0;
	}

	ALBEDO = vec3(1.0, 1.0, 1.0);
}
