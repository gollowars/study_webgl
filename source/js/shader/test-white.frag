

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float Tau = 6.2832;
const float density = .1;
const float shape = .04;

const float pi = 3.14159265359;

float random(vec2 seed) {
  return fract(sin(seed.x + seed.y * 1e3) * 1e5);
}

float Cell(vec2 coord) {
  coord = coord + length(coord - 0.5);
  vec2 cell = fract(coord) * vec2(.5,2.) - vec2(.0, .5);
  return (1. - length(cell*2.-1.)) * step(random(floor(coord)), density) * 2.;
}

void main() {
  vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x,resolution.y);

  float l = 0.03/length(p.y);



  gl_FragColor = vec4(vec3(1.0),1.0);
}