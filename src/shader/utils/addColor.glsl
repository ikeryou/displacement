vec4 addColor(vec4 cB, vec4 cA, float alpha) {
  return vec4((cA.rgb * vec3(cA.a)) + (cB.rgb * vec3(1.0 - cA.a)), alpha);
}

#pragma glslify: export(addColor)