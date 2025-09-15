shader_type canvas_item;
// 斜向条纹，可动画偏移

uniform float angle_degrees : hint_range(-90.0, 90.0) = 12.0;
uniform float frequency : hint_range(1.0, 80.0) = 20.0; // 条纹密度
uniform float contrast : hint_range(0.2, 3.0) = 1.0;
uniform float speed = 0.25;
uniform vec4 color_a : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color_b : source_color = vec4(0.9, 0.0, 0.35, 1.0);

void fragment(){
	float rad = radians(angle_degrees);
	vec2 dir = vec2(cos(rad), sin(rad));
	float t = TIME * speed;
	float v = dot(UV * frequency, dir) + t;
	float s = sin(v * 6.28318530718);
	float m = smoothstep(0.0, 1.0, s * 0.5 + 0.5);
	// 增强对比
	m = pow(m, max(0.0001, 1.0/contrast));
	COLOR = mix(color_a, color_b, m);
}


