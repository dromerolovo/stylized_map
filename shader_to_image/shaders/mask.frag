#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;

out vec4 FragColor;

const vec3 BACKGROUND = vec3(0.96, 0.92, 0.88);
const vec3 TRANSPARENT = vec3(0.0, 0.0, 0.0); 

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f*f*(3.0-2.0*f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}



void main() {
    vec2 st = FlutterFragCoord() / uSize;

    float aspectRatio = uSize.x / uSize.y;

    st.x *= aspectRatio;

    vec2 pos = vec2(st*5.0);

    float n = noise(pos * 20.0);

    float threshold = 0.5;

    vec3 color = (n > threshold) ? BACKGROUND : TRANSPARENT;

    FragColor = vec4(color, (n > threshold) ? 1.0 : 0.0);
}