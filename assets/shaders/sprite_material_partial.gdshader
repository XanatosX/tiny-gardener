shader_type spatial;

//uniform vec4 texture = vec4(0,0,0,0);
uniform sampler2D sprite_texture;
uniform float percentage = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 albedo = texture(sprite_texture, UV).rgb;
	ALBEDO = albedo;
	ALPHA = 1.0;
	//ALPHA = albedo.a;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
