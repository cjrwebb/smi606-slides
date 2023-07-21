sample <- 600*600
image_size <- 962*628

prop_sampled <- sample / image_size # around 40% of the pixels in the image

library(imager)

base_pic <- load.image("base-img.jpg")
plot(base_pic)
str(base_pic)

base_pic
bp_raster <- as.raster(base_pic, rescale = FALSE)

plot(bp_raster)

bp_raster_random1 <- bp_raster
bp_raster_random1[runif(image_size) >= prop_sampled] <- NA

plot(bp_raster_random1)

bp_raster_random2 <- bp_raster
bp_raster_random2[runif(image_size) >= 0.3] <- NA

plot(bp_raster_random2)

# non-response example: 
bp_raster_random3 <- bp_raster
bp_raster_random3_left <- bp_raster_random3[1:628, 1:600]
bp_raster_random3_left[runif(600*628) >= prop_sampled*1.5] <- NA

plot(bp_raster_random3_left)

bp_raster_random3 <- bp_raster
bp_raster_random3_right <- bp_raster_random3[1:628, 601:962]
bp_raster_random3_right[runif(628*(962-601)) >= prop_sampled*0.2] <- NA
plot(bp_raster_random3_right)


bp_raster_random3 <- bp_raster
bp_raster_random3_left <- bp_raster_random3[1:628, 1:600]
bp_raster_random3_left[runif(600*628) >= prop_sampled*(1.5*3/4)] <- NA

plot(bp_raster_random3_left)

bp_raster_random3 <- bp_raster
bp_raster_random3_right <- bp_raster_random3[1:628, 601:962]
bp_raster_random3_right[runif(628*(962-601)) >= prop_sampled*(0.2*3)] <- NA
plot(bp_raster_random3_right)


bp_raster_random3 <- bp_raster
bp_raster_random3_left <- bp_raster_random3[1:628, 1:600]
bp_raster_random3_left[runif(600*628) >= prop_sampled*(1.5*2/3)] <- NA

plot(bp_raster_random3_left)

bp_raster_random3 <- bp_raster
bp_raster_random3_right <- bp_raster_random3[1:628, 601:962]
bp_raster_random3_right[runif(628*(962-601)) >= prop_sampled*(0.2*5)] <- NA
plot(bp_raster_random3_right)


# Experimental design

set.seed(94759846)
x <- rnorm(100)
y <- rnorm(100)

library(tidyverse)

exp_group <- tibble(x, y)

exp_group$col <- sample(c("#E69F00", "#56B4E9", "#009E73", "#F0E441", "#0172B2", "#D55E00", "#CC79A7"), replace = TRUE, size = 100)
exp_group$pch <- sample(c("15", "16", "17", "18"), replace = TRUE, size = 100)


exp_group %>%
  ggplot() +
  geom_point(aes(x = x, y = y, pch = pch, col = col, size = 1)) +
  theme_void() +
  theme(legend.position = "none") +
  scale_color_identity()

set.seed(836)
exp_group$assignment <- sample(c("Experimental", "Control"), size = 100, prob = c(0.5, 0.5), replace = TRUE)

table(exp_group$assignment)

ggplot(exp_group) +
  geom_point(aes(x = col, y = pch, col = col, pch = pch), size = 3) +
  facet_wrap(vars(assignment)) +
  theme(legend.position = "none") +
  scale_color_identity() +
  theme(axis.title = element_blank(), axis.ticks = element_blank(), 
        plot.background = element_blank(), axis.text = element_blank(),
        panel.background = element_blank())

set.seed(976675)
exp_group$assignment <- sample(c("Experimental", "Control"), size = 100, prob = c(0.5, 0.5), replace = TRUE)

table(exp_group$assignment)

ggplot(exp_group) +
  geom_point(aes(x = col, y = pch, col = col, pch = pch), size = 3) +
  facet_wrap(vars(assignment)) +
  theme(legend.position = "none") +
  scale_color_identity() +
  theme(axis.title = element_blank(), axis.ticks = element_blank(), 
        plot.background = element_blank(), axis.text = element_blank(),
        panel.background = element_blank())



