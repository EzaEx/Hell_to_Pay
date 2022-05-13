//Shader by: Jordancjb (https://linktr.ee/jordancjb)
//Licensed under Creative Commons 0, Use as you like c:
shader_type canvas_item;

//Noise Texture
uniform sampler2D Noise;


float rand(vec2 co, float time, float noise){
    return fract(sin(dot(co.xy ,vec2(mod(12.9898 + time + noise, 100000), mod(78.233 + time * 2.124 + noise * 3.23523, 100000)))) * 43758.5453);
}

//Shader Code
void fragment() {
	float val = round(rand(UV, TIME, texture(Noise, UV).x)) / 2.0;

	COLOR = vec4(val, val, val, 1);
}