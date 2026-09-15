shader_type spatial;

uniform sampler2D TEX;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(TEX,vec2(UV.x*200.,UV.y*200.)).rgb;
	EMISSION = ALBEDO;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
