shader_type canvas_item;

uniform sampler2D u_color_tex;

// Every line was stolen from dither.gdshader
void fragment() {
	// Called for every pixel the material is visible on.
	
	ivec2 col_size = textureSize(u_color_tex, 0);
	col_size /= col_size.y;
	
	COLOR.rgb = texture(u_color_tex, vec2(COLOR.r*255., 0.5)).rgb; // Pretty sure this a fucked way to do it but hey ho
	COLOR.a = COLOR.a * 255.;
}
