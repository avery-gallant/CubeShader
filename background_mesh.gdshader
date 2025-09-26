shader_type spatial;
uniform sampler2D viewport_texture : filter_nearest;
uniform float threshold = 0.3;
void vertex(){

}
void fragment() {
    vec2 uv = UV; // Use UV for PlaneMesh
    vec4 tex_color = texture(viewport_texture, uv);
    ALBEDO = (tex_color.rgb);
}
void light() {

	float m = min(min(ALBEDO.r,ALBEDO.g),ALBEDO.b);
	float M = max(max(ALBEDO.r,ALBEDO.g),ALBEDO.b);
	float L = 0.5*(M+m);
	if (LIGHT_COLOR.r>5.0*PI&& ATTENUATION>0.5){
		DIFFUSE_LIGHT=vec3(1);
		SPECULAR_LIGHT = vec3(0.0);
	}
	else{
		if (L<threshold){
		    	DIFFUSE_LIGHT=vec3(1);
				SPECULAR_LIGHT = vec3(0.0);
			}
		else{
			DIFFUSE_LIGHT=vec3(0.0);
			SPECULAR_LIGHT = vec3(0.0);
		}
	}
}
