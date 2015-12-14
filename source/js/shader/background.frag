

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float strength;

const float density = .1;
const float shape   = .04;




float random(vec2 seed) {
  return fract(sin(seed.x + seed.y * 1e3) * 1e5);
}

float Cell(vec2 coord) {
    vec2 cell = fract(coord) * vec2(1.5, 2.) - vec2(.1, .5);
    // cell = fract(coord);

    return (1. - length(cell * 2. - 1.)) * step(random(floor(coord)), .000000000001) * .1;
}

void main() {
  vec2 mousePos = (mouse.xy - resolution * .5) / resolution.x;
  // mousePos.y *= -1.;
  vec2 position = (gl_FragCoord.xy - resolution * .5) / resolution.x + mousePos * .1;

  vec3 c = vec3(0.);
  float color = 1.;
  // float radian = atan(position.y, position.x) * PI1;
  float radius = length(position);
  float t = 0.2 / radius + time * .25;
  float st = sin(t);
  float ct = cos(t);


  vec3 pos = vec3(position + fract(sin(radius * radius)) * 5. + fract(cos(radius * 2.)), 1.);
  pos.xz *= mat2(ct * sin(time), st, -st, cos(t) * 15.234);
  pos.xy *= mat2(ct, -sin(t * 3.1342424), sin(t * t), -cos(t * 0.234));
  color = abs(snoise(pos)) * radius * .3;

  float radian = atan(pos.y, pos.x) * PI1;

  float a = fract(atan(position.x, position.y) / Tau);

  vec2 coord = vec2(pow(radius, .05) * 256., a * 128.);

  vec2 delta = vec2(-time * 10., Tau);


  float color2 = 0.;

  for (int i=0; i < 5; i++) {
    coord += delta;
    color2 += max(Cell(coord), color2);
  }
  
  c.xyz = vec3(color + color2 * radius);
  c.x *= clamp(abs(snoise(position + vec2(time + 500.)) * 2. - 1.), 1., 1.5);
  c.y *= clamp(abs(snoise(position + vec2(time + 100.)) * 2. - 1.), 1.1, 1.5);
  c.z *= clamp(abs(snoise(position + vec2(time)) * 2. - 1.), 1.1, 1.5);
  // float dt = (dot(position, coord) + time) * .01;
  // c.x *= sin(dt) * .5 + 1.;
  // c.y *= cos(dt) * .5 + 1.;
  // c.z *= tan(dt) * .5 + 1.;



  float l = length(c);

  gl_FragColor = vec4(c * strength, 1.);
  // gl_FragColor = vec4(c*1.0,1.);


}