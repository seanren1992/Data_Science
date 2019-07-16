### Data visualization R
### R_Kmeans
### Author: David Li

set.seed(2468)
wgss <- vector("numeric", 8)
plots <- vector("list", 9)
p1 <- ggplot(d, aes(NYGN, SPAD))

for(i in 2:9) {
 km <- kmeans(d[, .(NYGN, SPAD)],
            centers = i)
 wgss[i - 1] <- km$tot.withinss
 
 plots[[i - 1]] <- p1 +
   geom_point(aes_(colour = factor(km$cluster))) +
   scale_color_viridis(discrete = TRUE) +
   theme(legend.position = "none") +
   ggtitle(paste("kmeans centers = ", i))
}

plots[[9]] <- ggplot() +
  geom_point(aes(x = 2:9, y = wgss)) +
  xlab("Number of Clusters") +
  ylab("Within SS") +
  ggtitle("Scree Plot")
do.call(plot_grid, c(plots, ncol = 3))
