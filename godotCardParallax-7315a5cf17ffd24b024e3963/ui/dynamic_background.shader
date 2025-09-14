shader_type canvas_item;

uniform float time;
uniform vec4 base_color : hint_color = vec4(1.0, 0.0, 1.0, 1.0); // 洋红色
uniform float wave_frequency : hint_range(0.1, 10.0) = 2.0;
uniform float wave_amplitude : hint_range(0.0, 1.0) = 0.1;
uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.05;

void fragment() {
	// 基础波纹效果
	vec2 uv = UV;
	float wave = sin(uv.y * wave_frequency + time) * wave_amplitude;
	uv.x += wave;
	
	// 故障效果
	float glitch = fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453) * glitch_intensity;
	if (fract(uv.y * 10.0 + time) < 0.01) {
		glitch *= 5.0;
	}
	uv.x += glitch;
	
	// 颜色扰动
	vec3 color = base_color.rgb;
	color.r += sin(time * 2.0 + uv.x * 10.0) * 0.1;
	color.b += cos(time * 1.5 + uv.y * 8.0) * 0.1;
	
	// 创建流动效果
	float flow = sin(time + uv.x * 3.0 + uv.y * 2.0);
	color += flow * 0.1;
	
	COLOR = vec4(color, base_color.a);
}