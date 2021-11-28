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
	float contrast = 8.0;
	grayscale = (grayscale - 0.5) * contrast + 0.5;
	//clamp the value to avoid incorrect colors later
	grayscale = clamp(grayscale, 0.0, 1.0);
	//posterize the noise
	float posterization = 4.0;
	grayscale = floor(grayscale * posterization) / posterization;
	//mix between two colors using the grayscale value
	ALBEDO = mix(color1, color2, grayscale).rgb;
}