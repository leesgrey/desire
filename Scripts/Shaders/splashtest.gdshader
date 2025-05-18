/*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/pixelate

This shader is under CC0 license. Feel free to use, improve and
change this shader according to your needs and consider sharing
the modified result to godotshaders.com.
*/

shader_type canvas_item;

uniform int amount = 40;
uniform float threshold = 0.;
uniform vec3 color;
uniform bool invert = false;

void fragment()
{
	vec2 grid_uv = round(UV * float(amount)) / float(amount);

	vec4 text = texture(TEXTURE, grid_uv);

	if (text.a == 0.)
	{
		COLOR = vec4(0., 0., 0., 0.);
	}
	else
	{float gray = (text.r + text.g + text.b) / 3.;

	if (invert)
	{
		if (gray >= threshold){
			COLOR = vec4(0., 0., 0., 1.);
		}
		else
		{
			COLOR = vec4(color.r / 255., color.g / 255., color.b / 255., 1.);
		}
	}
	else
	{
		if (gray >= threshold){
			COLOR = vec4(color.r / 255., color.g / 255., color.b / 255., 1.);
		}
		else
		{
			COLOR = vec4(0., 0., 0., 1.);
		}
	}

	}
}
