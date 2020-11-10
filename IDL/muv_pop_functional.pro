FUNCTION MUV_POP_FUNCTIONAL, vp, Es=Es
  Er=13.61
  Eth=vp[-1]
  sigma = vp[0] * ((Es - Eth)/Er)^vp[1] / (1.+((Es - Eth)/vp[2])^(vp[1]+vp[3])) + vp[4] * ((Es - Eth)/Er)^vp[5] / (1.+((Es - Eth)/vp[6])^(vp[5]+vp[7]))
  return, sigma
END