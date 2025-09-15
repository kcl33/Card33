shader_type canvas_item;
// 黑色雨滴/雨线效果，叠加在前景

uniform vec4 rain_color : source_color = vec4(0.0, 0.0, 0.0, 0.4);
uniform float density : hint_range(50.0, 400.0) = 180.0;
uniform float length_scale : hint_range(0.1, 1.5) = 0.7;
uniform float speed = 0.8;
uniform float wind = 0.2; // x 偏移

float hash(vec2 p){ return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453); }

void fragment(){
    vec2 uv = UV;
    vec2 g = vec2(floor(uv.x * density), floor(uv.y * density));
    float rnd = hash(g);
    float lane = fract(uv.x * density + rnd * 10.0);
    float t = fract(uv.y * density + TIME * speed + rnd*5.0);
    // 形成竖直/斜向雨线
    float dx = abs(lane - 0.5 + wind * (t-0.5) * 0.3);
    float dy = (1.0 - t);
    float line = smoothstep(0.02, 0.0, dx) * smoothstep(0.0, length_scale, dy);
    COLOR = rain_color * line;
}


