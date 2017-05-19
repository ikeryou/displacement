float map(float val, float resMin, float resMax, float baseMin, float baseMax) {

  if(val < baseMin) {
    return resMin;
  }

  if(val > baseMax) {
    return resMax;
  }

  float p = (resMax - resMin) / (baseMax - baseMin);
  return ((val - baseMin) * p) + resMin;

}

#pragma glslify: export(map)