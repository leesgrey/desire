shader_type canvas_item;

uniform int pixellation = 40;
uniform float transparency_threshold;
uniform vec3 color;

void fragment()
{
	vec2 grid_uv = round(UV * float(pixellation)) / float(pixellation);

	vec4 text = texture(TEXTURE, grid_uv);

	if (text.r + text.g + text.b < transparency_threshold)
	{
		COLOR = vec4(0., 0., 0., 0.);
	}
	else
	{
		COLOR = vec4(color.r / 255., color.g / 255., color.b / 255., 1.);
	}
}
