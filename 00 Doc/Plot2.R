require(plotly)
require(ggplot2)
require(dplyr)
require(leaflet)
require(rgdal)

# Set working directory to 00 Doc.
source("../01 Data/ETL.R")

data <- data.frame(internet = df2$Avg_InternetUsage, state = df2$State)
map <- map_data("state")

m <- leaflet() %>%
     addTiles() %>%
     addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, color = ~pal(internet))
?addPolygons

pal <- colorNumeric(
  palette = "Blues",
  domain = data$internet
)
