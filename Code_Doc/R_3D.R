### Data visualization R
### R_3D
### Author: David Li

par(mfrow = c(2, 2), mar = c(.1, .1, .1, .1))
vis.gam(mgam7,
  view = c("CESD11_W1", "SelfEsteem_W1"),
  theta = 210, phi = 40,
  color = "topo",
  plot.type = "persp")
vis.gam(mgam7,
  view = c("CESD11_W1", "SelfEsteem_W1"),
  theta = 150, phi = 40,
  color = "topo",
  plot.type = "persp")
vis.gam(mgam7,
  view = c("CESD11_W1", "SelfEsteem_W1"),
  theta = 60, phi = 40,
  color = "topo",
  plot.type = "persp")
vis.gam(mgam7,
  view = c("CESD11_W1", "SelfEsteem_W1"),
  theta = 10, phi = 40,
  color = "topo",
  plot.type = "persp")
