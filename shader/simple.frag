//
//   Fragment Shader
//

// Vert shader variables

varying vec3 n;
varying vec3 v;


uniform vec4 Color;

void main(void)
{
  vec4 ambient = gl_FrontLightProduct[0].ambient;

  vec3 l = normalize(gl_LightSource[0].position.xyz - v);
  vec4 diff = gl_FrontLightProduct[0].diffuse * max(dot(n, l), 0.0);
  diff = clamp(diff, diff, diff);

  gl_FragColor = (diff + ambient) * Color;
}
