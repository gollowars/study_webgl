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

  float l = sin(11.4 / length(p - vec2(sin(time*15.2)*0.1,cos(time*15.2)*0.1))*time)*0.4;

  gl_FragColor = vec4(vec3(l),1.0);
}
