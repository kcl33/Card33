shader_type canvas_item;
// 斜向扫光，用于肩标/标题高光

uniform float angle_degrees = 20.0;
uniform float width = 0.2;
uniform float speed = 1.0;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 0.6);

void fragment(){
    float rad = radians(angle_degrees);
    vec2 dir = vec2(cos(rad), sin(rad));
    float t = fract(TIME * speed);
    float v = dot(UV - vec2(t, 0.0), dir);
    float m = smoothstep(0.0, width, v) * (1.0 - smoothstep(width, width*2.0, v));
    COLOR = color * m;
}


