

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
  vec2 center = vec2(-mouse.x * resolution.x, mouse.y * resolution.y);
  vec2 position = (gl_FragCoord.xy + center - resolution.xy * .5) / resolution.x;
  float rad = length(position);

  float angle = atan(position.x, position.y)/(pi);

  float _time = time * 1.;
  float color = 0.;
  float t2 = _time * 15.;


  float s = (sin(rad * 100. - t2) + 1.) / 2. + (cos(rad * 250. - t2) + 1.) / 2. * 1.2 + 0.5;
  color += s * rad * 0.08;

  for(int i = 0; i < 1; i++) {
    float angleFract = fract(angle * 256.);
    float angleRnd = floor(angle * 256.);
    float angleRnd1 = fract(angleRnd * fract(angleRnd*.724) * 45.1);
    float angleRnd2 = fract(angleRnd * fract(angleRnd*.8) * 13.234);
    float t = _time + angleRnd1 * 10.;
    float radDist = sqrt(angleRnd2 + float(i));

    float adist = radDist / rad * .1;
    float dist = (t * .1 + adist);
    dist = abs(fract(dist) - .5)*0.5;
    color += max(0., .5 - dist * 40. / adist) * (.5 - abs(angleFract - .5)) * 5. / adist / radDist;
    angle = fract(angle + .61);
  }

  // if(length(position) < 0.5){
  //   float l = 1.0-12.0*length(position);
  //   color += l;
  // }


  gl_FragColor = vec4(color) * .2;
}