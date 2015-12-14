varying vec2 vUv;
varying vec4 worldPos;

uniform sampler2D texture;
uniform vec3 cover;
uniform float opacity;
uniform vec2 cellsize;
uniform float frame;
uniform float offset;

void main() {
  float z = worldPos.z;
  // gl_FragColor = texture2D(texture, vUv) * (1. - depth/1000.);
  // vec3 overcolor =
  float u = mod(frame, 6.) * cellsize.x;
  float v = (5. - floor(frame / 6.)) * cellsize.y + offset;

  // float depth = 1. - z/2500.;
  float depth = max(0., 1.0333333333 - max(z, 250.) / 3000.);
  // gl_FragColor = vec4(color, 0, 0, 1.);

  // gl_FragColor = vec4(cover * depth, alpha);
  vec3 txcolor = vec3(texture2D(texture, vUv * cellsize + vec2(u, v)));
  vec3 color = vec3(max(txcolor.r, cover.r), max(txcolor.g, cover.g), max(txcolor.b, cover.b));
  color = (mix(color, txcolor, .5) - .5) * 1.7 + .5 + .2;
  gl_FragColor = vec4(color * depth, opacity);
}