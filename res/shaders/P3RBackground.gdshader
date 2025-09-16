shader_type canvas_item;

uniform float time_scale : hint_range(0.0, 2.0) = 1.0;
uniform float wave_amplitude : hint_range(0.0, 0.5) = 0.1;
uniform float wave_frequency : hint_range(0.0, 10.0) = 2.0;
uniform vec4 color1 : source_color = vec4(0.1, 0.3, 0.8, 1.0);
uniform vec4 color2 : source_color = vec4(0.2, 0.1, 0.6, 1.0);
uniform vec4 color3 : source_color = vec4(0.05, 0.1, 0.4, 1.0);
uniform float gradient_speed : hint_range(0.0, 5.0) = 1.0;
uniform float noise_scale : hint_range(0.0, 20.0) = 5.0;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.3;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = UV;
    float time = TIME * time_scale;
    
    // 创建流动的波浪效果
    float wave1 = sin(uv.x * wave_frequency + time * gradient_speed) * wave_amplitude;
    float wave2 = sin(uv.y * wave_frequency * 0.7 + time * gradient_speed * 1.3) * wave_amplitude * 0.5;
    
    // 添加噪声
    float noise_value = noise(uv * noise_scale + time * 0.5) * noise_strength;
    
    // 创建径向渐变
    vec2 center = vec2(0.5, 0.3);
    float dist = distance(uv, center);
    float radial = 1.0 - smoothstep(0.0, 0.8, dist);
    
    // 创建对角线渐变
    float diagonal = (uv.x + uv.y) * 0.5 + wave1 + wave2 + noise_value;
    
    // 混合颜色
    vec3 color = mix(color1.rgb, color2.rgb, diagonal);
    color = mix(color, color3.rgb, radial * 0.5);
    
    // 添加发光效果
    float glow = sin(time * 2.0 + diagonal * 10.0) * 0.1 + 0.9;
    color *= glow;
    
    COLOR = vec4(color, 1.0);
}
