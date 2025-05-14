shader_type spatial;

void light() {
	float m = min(min(ALBEDO.r,ALBEDO.g),ALBEDO.b);
	float M = max(max(ALBEDO.r,ALBEDO.g),ALBEDO.b);
	float L = 0.5*(M+m);
	if (LIGHT_COLOR.r>5.0*PI&& ATTENUATION>0.5){
		DIFFUSE_LIGHT  = vec3(0.9,0.9,1.0);
	}
	else{
		if (L<0.3){
		    	DIFFUSE_LIGHT.r = 0.9;
				DIFFUSE_LIGHT.g = 0.9;
				DIFFUSE_LIGHT.b = 1.0;

			}
		else{
			DIFFUSE_LIGHT.r = 0.0;
			DIFFUSE_LIGHT.g = 0.0;
			DIFFUSE_LIGHT.b = 0.0;
		}
	}
}
