shader_type canvas_item;

uniform vec4 block_color: source_color;
const float max_diff = 0.5/255.0;

bool color_match(vec4 c1, vec4 c2) {
    return (abs(c1.r - c2.r) < max_diff && abs(c1.g - c2.g) < max_diff && abs(c1.b - c2.b) < max_diff);
}

void fragment() {
	if (color_match(texture(TEXTURE, UV), block_color)) { 
		COLOR.a = 0.0; 
	}
}
