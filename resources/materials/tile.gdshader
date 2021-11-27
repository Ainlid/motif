shader_type spatial;
render_mode unshaded;

uniform sampler2D gradient : hint_albedo;
uniform sampler2D noise : hint_black;

void fragment()
{
	vec2 uvs = UV;
	float grayscale = texture(noise, uvs).r;
	grayscale = floor(grayscale * 4.0) / 4.0;
	ALBEDO = texture(gradient, vec2(grayscale, 0.0)).rgb;
}