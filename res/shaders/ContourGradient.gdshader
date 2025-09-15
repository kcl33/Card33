shader_type canvas_item;
// 等高线+渐变背景

uniform vec4 color_bg : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color_fg : source_color = vec4(0.9, 0.0, 0.35, 1.0);
uniform float line_width = 0.006;
uniform float line_spacing = 0.06;
uniform float flow_speed = 0.02;
uniform float radial_mix : hint_range(0.0,1.0) = 0.4; // 0线性 1径向

float contour(vec2 uv){
	float t = TIME * flow_speed;
	float h = fract(uv.y / max(0.0001, line_spacing) + t);
	float edge = smoothstep(0.0, line_width, min(h, 1.0 - h));
	return edge;
}

void fragment(){
	vec2 uv = UV;
	// 渐变
	float g_linear = uv.y;
	float g_radial = length(uv - vec2(0.5));
	float g = mix(g_linear, g_radial, radial_mix);
	vec4 grad = mix(color_bg, color_fg, g);
	float c = contour(uv);
	vec4 line_col = vec4(1.0);
	line_col.rgb = mix(grad.rgb, vec3(1.0) - grad.rgb, 0.5);
	vec4 col = mix(grad, line_col, c);
	COLOR = col;
}


