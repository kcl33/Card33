shader_type canvas_item;
// 灰色小波点 + 大圆球缓慢浮现/流动/消散

uniform vec4 dot_color : source_color = vec4(0.6, 0.6, 0.6, 1.0);
uniform float dot_density : hint_range(10.0, 200.0) = 80.0; // 每单位的点阵频率
uniform float dot_scale = 1.0;
uniform float dot_jitter = 0.15; // 抖动

uniform vec4 circle_color : source_color = vec4(0.9, 0.0, 0.35, 0.15);
uniform float circle_count : hint_range(1.0, 12.0) = 5.0;
uniform float circle_min_r = 0.05;
uniform float circle_max_r = 0.25;
uniform float circle_speed = 0.05;

float hash(vec2 p){
    return fract(sin(dot(p, vec2(41.3, 289.1))) * 43758.5453);
}

void fragment(){
    vec2 uv = UV;
    // 点阵
    vec2 grid = floor(uv * dot_density);
    vec2 cell = fract(uv * dot_density) - 0.5;
    float jitter = (hash(grid) - 0.5) * dot_jitter;
    float d = length(cell + jitter);
    float dot_mask = smoothstep(0.35 * dot_scale, 0.3 * dot_scale, d);
    vec4 dot_col = dot_color * dot_mask;

    // 漂浮圆球
    vec4 csum = vec4(0.0);
    for (int i = 0; i < 16; i++){
        if (float(i) >= circle_count) break;
        float fi = float(i);
        float r = mix(circle_min_r, circle_max_r, hash(vec2(fi, 10.3)));
        vec2 ctr = vec2(hash(vec2(fi, 2.1)), hash(vec2(fi, 7.7)));
        // 缓慢偏移
        ctr += vec2(sin(TIME*circle_speed + fi)*0.05, cos(TIME*circle_speed*0.7 + fi)*0.05);
        float m = smoothstep(r, r*0.9, distance(uv, ctr));
        csum += circle_color * m;
    }

    COLOR = dot_col + csum;
}


