## Rayshader Intro code from https://www.tylermw.com/3d-ggplots-with-rayshader/

# Install rayshader:
# Note: on Mac, it requires installation of XQuartz: https://www.xquartz.org/
# DevTools needs to be installed in R:
#install.packages("rayshader")
#install.packages("rgdal")

#### Load Required Packages ####
library(rayshader)
library(ggplot2)
library(tidyverse)
library(viridis)
library(rgdal)

#### Sample Plot with diamonds data ####

gg = ggplot(diamonds, aes(x, depth)) +
  stat_density_2d(aes(fill = stat(nlevel)), 
                  geom = "polygon",
                  n = 100,bins = 10,contour = TRUE) +
  facet_wrap(clarity~.) +
  scale_fill_viridis_c(option = "A")
plot_gg(gg,multicore=TRUE,width=5,height=5,scale=250)

#### Data from Social Security Administration ####

death = read_csv("https://www.tylermw.com/data/death.csv", skip = 1)
meltdeath = reshape2::melt(death, id.vars = "Year")  # Note here the use of the double colons: 
                                                     # it pulls a command from a package without having to load it.
meltdeath$age = as.numeric(meltdeath$variable)

deathgg = ggplot(meltdeath) +
  geom_raster(aes(x=Year,y=age,fill=value)) +
  scale_x_continuous("Year",expand=c(0,0),breaks=seq(1900,2010,10)) +
  scale_y_continuous("Age",expand=c(0,0),breaks=seq(0,100,10),limits=c(0,100)) +
  scale_fill_viridis("Death\nProbability\nPer Year",trans = "log10",breaks=c(1,0.1,0.01,0.001,0.0001), labels = c("1","1/10","1/100","1/1000","1/10000")) +
  ggtitle("Death Probability vs Age and Year for the USA") +
  labs(caption = "Data Source: US Dept. of Social Security")

plot_gg(deathgg, multicore=TRUE,height=5,width=6,scale=500)

render_depth(focallength=10,focus=1)

#### Maps from https://www.rayshader.com/ ####

#Here, I load a map with the raster package.
loadzip = tempfile() 
download.file("https://tylermw.com/data/dem_01.tif.zip", loadzip)
localtif = raster::raster(unzip(loadzip, "dem_01.tif"))
unlink(loadzip)

#And convert it to a matrix:
elmat = raster_to_matrix(localtif)

#We use another one of rayshader's built-in textures:
elmat %>%
  sphere_shade(texture = "desert") %>%
  plot_map()

#sphere_shade can shift the sun direction:
elmat %>%
  sphere_shade(sunangle = 45, texture = "desert") %>%
  plot_map()

#detect_water and add_water adds a water layer to the map:
elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  plot_map()

elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  add_shadow(ray_shade(elmat, zscale = 3), 0.5) %>%
  add_shadow(ambient_shade(elmat), 0) %>%
  plot_3d(elmat, zscale = 10, fov = 0, theta = 135, zoom = 0.75, phi = 45, windowsize = c(1000, 800))
Sys.sleep(0.2)
render_snapshot(clear=TRUE)

# For more info on creating map data sets, check out: https://wcmbishop.github.io/rayshader-demo/ 

montereybay %>%
  sphere_shade(zscale = 10, texture = "imhof1") %>%
  add_shadow(ray_shade(montereybay, zscale = 50)) %>%
  add_shadow(ambient_shade(montereybay, zscale = 50)) %>%
  plot_3d(montereybay, zscale = 50, theta = -45, phi = 45, water = TRUE,
          windowsize = c(1000,800), zoom = 0.75, waterlinealpha = 0.3,
          wateralpha = 0.5, watercolor = "lightblue", waterlinecolor = "white")
render_snapshot()


