precision mediump float;
uniform vec2  resolution;    // resolution (window.width, window.height)
uniform vec2  mouse;         // mouse      (-1.0 ~ 1.0)
uniform float time;          // time       (1second == 1.0)
// uniform sampler2D prevScene; // previous scene texture

const int   oct  = 8;
const float per  = 0.5;
const float PI   = 3.1415926;
const float cCorners = 1.0 / 16.0;
const float cSides   = 1.0 / 8.0;
const float cCenter  = 1.0 / 4.0;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main(){
  vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x,resolution.y);

  vec3 destColor = vec3(0.0);
  float speed = 0.5;
  float radius = 0.4;
  float size = 0.15;
  float distan = 2.1;

  for(float i = 0.0; i < 10.0; i++){
    float j = i + 1.0;

    float actRad =  radius;

    vec2 q = p + vec2(sin(time*speed + j*distan)*actRad,cos(time*speed + j*distan)*actRad);
    float l = size/length(q) * abs(cos(time*speed));
    vec3 circle = vec3(l - 1.0,l - abs(cos(gl_FragCoord.x)),l - abs(cos(gl_FragCoord.y)));
    destColor += circle;
  }


  gl_FragColor = vec4(vec3(destColor),1.0);
}
