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

void fragment() {
    vec2 uv = UV;
    float t = TIME * time_scale;
    
    // 创建雨滴
    float rain = 0.0;
    
    // 小雨效果
    if (rain_intensity < 0.6) {
        // 稀疏的雨滴，从上往下流
        for (int i = 0; i < 30; i++) {
            // 更随机的X位置分布
            float x = rand(vec2(float(i), 0.0)) + sin(t * 0.1 + float(i) * 0.8) * 0.05;
            // 固定的轻微倾斜角度（不随时间变化）
            float tilt = 0.15; // 轻微向右倾斜
            
            // 从上往下流动
            float drop_y = 1.0 - uv.y; // 从顶部(1.0)到底部(0.0)
            float y = fract(drop_y * 1.8 + t * rain_speed + float(i) * 0.3 + uv.x * tilt);
            
            // 雨滴宽度和长度
            float drop_width = 0.0006 * rain_size;
            float drop_length = 0.12 * rain_size;
            
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
        for (int i = 0; i < 60; i++) {
            // 更随机的X位置分布
            float x = rand(vec2(float(i), 1.0)) + sin(t * 0.2 + float(i) * 0.6) * 0.08;
            // 固定的轻微倾斜角度（不随时间变化）
            float tilt = 0.18; // 轻微向右倾斜
            
            // 从上往下流动
            float drop_y = 1.0 - uv.y; // 从顶部(1.0)到底部(0.0)
            float y = fract(drop_y * 2.2 + t * rain_speed * 1.3 + float(i) * 0.25 + uv.x * tilt);
            
            // 雨滴宽度和长度
            float drop_width = 0.001 * rain_size;
            float drop_length = 0.18 * rain_size;
            
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
