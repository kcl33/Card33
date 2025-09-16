shader_type canvas_item;

uniform float time_scale : hint_range(0.1, 5.0) = 1.0;
uniform float rain_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float rain_speed : hint_range(0.1, 10.0) = 2.0;
uniform float rain_size : hint_range(0.1, 2.0) = 1.0;
uniform float rain_opacity : hint_range(0.0, 1.0) = 0.8;
uniform vec4 rain_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 fp = fract(p);
    fp = fp * fp * (3.0 - 2.0 * fp);
    return mix(mix(rand(ip), rand(ip + vec2(1.0, 0.0)), fp.x),
               mix(rand(ip + vec2(0.0, 1.0)), rand(ip + vec2(1.0, 1.0)), fp.x), fp.y);
}

void fragment() {
    vec2 uv = FRAGMENT_COORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy;
    vec2 screen_res = (1.0 / SCREEN_PIXEL_SIZE).xy;
    float aspect_ratio = screen_res.x / screen_res.y;
    
    float t = TIME * time_scale;
    
    // 创建雨滴
    float rain = 0.0;
    
    // 小雨效果
    if (rain_intensity < 0.6) {
        // 稀疏的雨滴
        for (int i = 0; i < 20; i++) {
            float x = float(i) * 0.1 + sin(t * 0.5 + float(i)) * 0.1;
            float y = fract(uv.y * 2.0 + t * rain_speed + float(i) * 0.3);
            float drop_width = 0.002 * rain_size;
            float drop_length = 0.1 * rain_size;
            
            if (abs(uv.x - x) < drop_width && y < drop_length) {
                rain += (1.0 - y / drop_length) * 0.3;
            }
        }
    } else {
        // 暴雨效果
        for (int i = 0; i < 50; i++) {
            float x = float(i) * 0.05 + sin(t * 0.8 + float(i)) * 0.05;
            float y = fract(uv.y * 3.0 + t * rain_speed * 1.5 + float(i) * 0.2);
            float drop_width = 0.003 * rain_size;
            float drop_length = 0.15 * rain_size;
            
            if (abs(uv.x - x) < drop_width && y < drop_length) {
                rain += (1.0 - y / drop_length) * 0.6;
            }
        }
    }
    
    // 添加一些随机性
    rain += noise(uv * 50.0 + t * 0.1) * 0.1 * rain_intensity;
    
    // 应用颜色和透明度
    vec3 final_color = rain_color.rgb * rain;
    float final_alpha = rain * rain_opacity * rain_color.a;
    
    COLOR = vec4(final_color, final_alpha);
}
