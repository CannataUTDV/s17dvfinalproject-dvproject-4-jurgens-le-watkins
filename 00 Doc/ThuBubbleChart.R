library(plotly)
library(RColorBrewer)
source("../01 Data/ETL.R")

p <- plot_ly(df2, x = ~df2$PerCapitaIncome, y = ~df2$Avg_InternetUsage, text = ~df2$State, type = 'scatter', mode = 'markers', size = ~df2$PerCapitaIncome, color = ~State, colors = 'Paired',
             marker = list(opacity = 0.5, sizemode = 'diameter')) %>%
  layout(title = 'Per Capita Income and Average Internet Usage By State',
         xaxis = list(showgrid = TRUE, title = "Average Internet Usage"),
         yaxis = list(showgrid = TRUE, title = "Per CapitaI ncome"),
         showlegend = FALSE)
p
