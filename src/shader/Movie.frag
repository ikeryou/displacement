uniform sampler2D tDiffuse0;
uniform sampler2D tDiffuse1;
uniform sampler2D tMask;
// uniform sampler2D tMov;
uniform float strength;
uniform float offsetX;
uniform float offsetY;
uniform bool showMask;
uniform bool showDiffuse0;
uniform bool showDiffuse1;

varying vec2 vUv;

void main(void) {

  vec4 mask = texture2D(tMask, vUv);

  if(showMask) {

    gl_FragColor = mask;

  } else {

    if(showDiffuse0) {
      gl_FragColor = texture2D(tDiffuse0, vUv);
    }

    if(showDiffuse1) {
      gl_FragColor = texture2D(tDiffuse1, vUv);
    }

    if(showDiffuse0 == false && showDiffuse1 == false) {

    //  vec2 offset = vec2(mask.r) * strength * 0.01;
      //vec2 uv = fract(vUv + offset * vec2(offsetX * 0.01, offsetY * 0.01));

      vec4 dest0 = texture2D(tDiffuse0, vUv);
      vec4 dest1 = texture2D(tDiffuse1, vUv);


      mask.a = 1.0;
      vec4 dest = dest0 * mask + dest1 * (1.0 - mask);



      //dest.rgb = dest0.rgb * mask.rgb + dest1.rgb * (1.0 - mask.rgb);
      // dest.rgb *= dest0.rgb * mask.a + dest1.rgb * (1.0 - mask.a);

      gl_FragColor = dest;

    }

  }

}
