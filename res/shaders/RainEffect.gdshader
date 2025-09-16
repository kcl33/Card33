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
    vec2 uv = UV;
    vec2 screen_res = 1.0 / SCREEN_PIXEL_SIZE;
    float aspect_ratio = screen_res.x / screen_res.y;
    
    float t = TIME * time_scale;
    
    // 创建雨滴
    float rain = 0.0;
    
    // 小雨效果
    if (rain_intensity < 0.6) {
        // 稀疏的雨滴，从上往下流
        for (int i = 0; i < 30; i++) {
            // 随机X位置
            float x = float(i) * 0.08 + sin(t * 0.3 + float(i) * 1.7) * 0.15;
            // 从上往下流动，添加随机倾斜
            float tilt = sin(float(i) * 2.3) * 0.1; // 随机倾斜角度
            float y = fract(uv.y * 1.5 + t * rain_speed + float(i) * 0.4 + uv.x * tilt);
            // 更细的雨滴
            float drop_width = 0.001 * rain_size;
            float drop_length = 0.08 * rain_size;
            
            if (abs(uv.x - x) < drop_width && y < drop_length) {
                rain += (1.0 - y / drop_length) * 0.4;
            }
        }
    } else {
        // 暴雨效果，从上往下流
        for (int i = 0; i < 60; i++) {
            // 随机X位置
            float x = float(i) * 0.05 + sin(t * 0.6 + float(i) * 1.3) * 0.08;
            // 从上往下流动，添加随机倾斜
            float tilt = sin(float(i) * 1.8) * 0.15; // 随机倾斜角度
            float y = fract(uv.y * 2.0 + t * rain_speed * 1.2 + float(i) * 0.3 + uv.x * tilt);
            // 更细的雨滴
            float drop_width = 0.0015 * rain_size;
            float drop_length = 0.12 * rain_size;
            
            if (abs(uv.x - x) < drop_width && y < drop_length) {
                rain += (1.0 - y / drop_length) * 0.7;
            }
        }
    }
    
    // 添加一些随机性
    rain += noise(uv * 80.0 + t * 0.05) * 0.05 * rain_intensity;
    
    // 应用更白的颜色和透明度
    vec3 final_color = vec3(1.0, 1.0, 1.0) * rain; // 纯白色
    float final_alpha = rain * rain_opacity * 0.8; // 稍微降低透明度
    
    COLOR = vec4(final_color, final_alpha);
}
