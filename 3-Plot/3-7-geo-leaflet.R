#############################
#geoplot
#############################
install.packages("leaflet")
library(leaflet)

m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
m
#########
nthu <- leaflet()
nthu <- addTiles(nthu)
nthu <- addMarkers(nthu, lng=120.9967, lat=24.7961, popup="The NTHU Campus")
nthu
#########



