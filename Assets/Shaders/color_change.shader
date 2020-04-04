shader_type canvas_item;
render_mode unshaded;

uniform vec4 new_color : hint_color;

//$sprite.material.set_shader_param("_outline", true)

void fragment() {
	COLOR = texture(TEXTURE, UV);
	vec4 screen = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	//checks if pixel is transparent and neighbors are not, gives outline
	if(COLOR.a != 0.0 ) {
		COLOR = new_color
	}
}