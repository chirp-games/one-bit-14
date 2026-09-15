shader_type canvas_item;
uniform sampler2D u_color_tex;

void fragment() {
	if (COLOR.r > 0.6 || texture(TEXTURE, UV - TEXTURE_PIXEL_SIZE).r > 0.6 || texture(TEXTURE, vec2(UV.x + TEXTURE_PIXEL_SIZE.x,UV.y - TEXTURE_PIXEL_SIZE.y)).r > 0.6) {
		COLOR = texture(u_color_tex, vec2(1.0));
	}
	else {
		COLOR = vec4(0.0);
	}
}
