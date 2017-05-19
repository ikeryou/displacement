float brightness(vec4 color) {
  return color.r * 0.298912 + color.g * 0.586611 + color.b * 0.114478;
}

#pragma glslify: export(brightness)
