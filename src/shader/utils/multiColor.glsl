vec4 multiColor(vec4 cB, vec4 cA, float alpha) {
  return vec4(cB.rgb * cA.rgb, alpha);
}

#pragma glslify: export(multiColor)