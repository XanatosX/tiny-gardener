// Based on https://gdshader.com/shaders/39
// Influenced by https://mastodon.gamedev.place/@memoriesin8bit/117149983884735773
shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float blur_amount : hint_range(0.0, 5.0);
uniform vec3 glass_color: source_color = vec3(0,0,0);
uniform float glass_mix_strength: hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 color = textureLod(screen_texture, SCREEN_UV, blur_amount);
	
    COLOR = color;
	COLOR.rgb = mix(COLOR.rgb, glass_color, glass_mix_strength);
}