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


  vec3 destColor = vec3(0.0);

  vec2 p = (gl_FragCoord.xy*2.0 - resolution) / min(resolution.x,resolution.y);

  for(float i = 0.0;i < 10.0; i++){
    float j = i + 1.0;
    vec2 q = p - vec2(cos(time*10.5+(j+11.5))*0.35,sin(time*10.5+(j+11.5))*0.35);
    float l = 0.001/abs(length(q) - abs(cos(time*4.0)));
    vec3 c = vec3(l-1.0,l-0.04,l);
    destColor += c;
  }


  // destColor = vec3(1.0);
  gl_FragColor = vec4(destColor,1.0);
}
