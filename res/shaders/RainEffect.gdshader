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
    float t = TIME * time_scale;
    
    // 创建雨滴
    float rain = 0.0;
    
    // 小雨效果
    if (rain_intensity < 0.6) {
        // 稀疏的雨滴，从上往下流
        for (int i = 0; i < 25; i++) {
            // 随机X位置
            float x = float(i) * 0.12 + sin(t * 0.2 + float(i) * 1.5) * 0.2;
            // 随机倾斜角度
            float tilt = sin(float(i) * 2.1) * 0.08;
            // 从上往下流动 - 关键修复：使用1.0 - uv.y确保从上往下
            float drop_y = 1.0 - uv.y; // 从顶部(1.0)到底部(0.0)
            float y = fract(drop_y * 2.0 + t * rain_speed + float(i) * 0.5 + uv.x * tilt);
            
            // 雨滴宽度和长度
            float drop_width = 0.0008 * rain_size;
            float drop_length = 0.15 * rain_size;
            
            // 检查是否在雨滴范围内
            if (abs(uv.x - x) < drop_width && y < drop_length) {
                // 添加拖尾效果
                float trail = 1.0 - (y / drop_length);
                trail = trail * trail; // 让拖尾更自然
                rain += trail * 0.6;
            }
        }
    } else {
        // 暴雨效果，从上往下流
        for (int i = 0; i < 50; i++) {
            // 随机X位置
            float x = float(i) * 0.08 + sin(t * 0.4 + float(i) * 1.2) * 0.12;
            // 随机倾斜角度
            float tilt = sin(float(i) * 1.7) * 0.12;
            // 从上往下流动 - 关键修复：使用1.0 - uv.y确保从上往下
            float drop_y = 1.0 - uv.y; // 从顶部(1.0)到底部(0.0)
            float y = fract(drop_y * 2.5 + t * rain_speed * 1.5 + float(i) * 0.4 + uv.x * tilt);
            
            // 雨滴宽度和长度
            float drop_width = 0.0012 * rain_size;
            float drop_length = 0.2 * rain_size;
            
            // 检查是否在雨滴范围内
            if (abs(uv.x - x) < drop_width && y < drop_length) {
                // 添加拖尾效果
                float trail = 1.0 - (y / drop_length);
                trail = trail * trail; // 让拖尾更自然
                rain += trail * 0.8;
            }
        }
    }
    
    // 应用纯白色和合适的透明度
    vec3 final_color = vec3(1.0, 1.0, 1.0); // 纯白色
    float final_alpha = rain * rain_opacity;
    
    COLOR = vec4(final_color, final_alpha);
}
