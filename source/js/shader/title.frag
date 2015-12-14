varying vec2 vUv;
varying vec4 worldPos;

uniform sampler2D texture;
uniform float opacity;

void main() {
  vec4 txtcolor = vec4(texture2D(texture, vUv));
  float z = worldPos.z;
  float depth = max(0., 2. - max(z, 2000.) / 2000.);
  gl_FragColor = txtcolor * depth * opacity;
}