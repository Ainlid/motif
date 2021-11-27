shader_type spatial;

uniform sampler2D gradient : hint_albedo;
uniform sampler2D noise : hint_black;

void fragment()
{
	vec2 uvs = UV;
	float grayscale = texture(noise, uvs).r;
	float colors_amount = 4.0;
	grayscale = floor(grayscale * colors_amount) / colors_amount;
	ALBEDO = texture(gradient, vec2(grayscale, 0.0)).rgb;
}