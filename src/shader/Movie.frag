uniform sampler2D tDiffuse;
uniform sampler2D tMask;
uniform float strength;
uniform float offsetX;
uniform float offsetY;
uniform bool showMask;
uniform bool useDiffuse;

varying vec2 vUv;

void main(void) {

  vec4 mask = texture2D(tMask, vUv);

  if(showMask) {
    gl_FragColor = mask;
  } else {
    vec2 offset = vec2(mask.r, mask.g) * strength * 0.01;
    vec4 dest = texture2D(tDiffuse, fract(vUv + offset * vec2(offsetX * 0.01, offsetY * 0.01)));

    gl_FragColor = dest;
  }

}
