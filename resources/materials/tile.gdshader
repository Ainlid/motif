shader_type spatial;

uniform vec4 color1 : hint_color = vec4(1.0);
uniform vec4 color2 : hint_color = vec4(1.0);
uniform sampler2D noise : hint_black;

void fragment()
{
	vec2 uvs = UV;
	//multiply the UVs to get repeating pattern
	uvs *= 4.0;
	float grayscale = texture(noise, uvs).r;
	//posterize the noise
	float posterization = 8.0;
	float grayscale_post = floor(grayscale * posterization) / posterization;
	float lines = grayscale - 0.5;
	lines = abs(lines);
	lines *= 10.0;
	lines = smoothstep(0.4, 0.6, lines);
	//lines = step(0.5, lines);
	float pattern = lines - grayscale_post;
	pattern = clamp(pattern, 0.0, 1.0);
	//mix between two colors using the grayscale value
	ALBEDO = mix(color1, color2, pattern).rgb;
}