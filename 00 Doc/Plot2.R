library(plotly)
library(RColorBrewer)

source("../01 Data/ETL.R")
df2$adult20to29 <- df2$male20to29 + df2$female20to29
p <- plot_ly(x = ~list(df2$Avg_InternetUsage), y = ~list(df2$Avg_InternetUsageAtCoffeeShops), z = ~list(df2$adult20to29),marker = list(color = ~mpg, colorscale = c('#FFE1A1', '#683531'), showscale = FALSE), hoverinfo = 'text', text = ~paste('Internet Usage (Avg): ', df2$Avg_InternetUsage, '</br>Coffee Shops (Avg): ', df2$Avg_InternetUsageAtCoffeeShops,'</br> Young Adult Population: ', df2$df2$adult20to29), color = df2$State) %>%add_markers() %>%layout(scene = list(xaxis = list(title = 'Avg_InternetUsage'),yaxis = list(title = 'CoffeeShops'),zaxis = list(title = 'Young adult')))
p
