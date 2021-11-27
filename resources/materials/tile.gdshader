shader_type spatial;
render_mode cull_disabled;

uniform vec4 col : hint_color = vec4(1.0);
uniform vec2 seed = vec2(0.137, 0.519);

float hash(vec2 p) {
  return fract(sin(dot(p * 17.17, seed)) * 4791.9511);
}

void fragment()
{
	vec2 uvs = UV;
	uvs = floor(uvs * 16.0) /16.0;
	float noise = hash(uvs);
	noise = floor(noise * 2.0) / 2.0;
	noise = ceil(noise);
	float grayscale = mix(0.8, 1.0, noise);
	ALBEDO = vec3(grayscale) * col.rgb;
}