shader_type canvas_item;

uniform float borderSize = 2.0;

void vertex() {
	//
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	
	if (col.a == 1.0) {
		COLOR = col;
	} else {
		COLOR = vec4(0, 0, 0, 1);
	}
}