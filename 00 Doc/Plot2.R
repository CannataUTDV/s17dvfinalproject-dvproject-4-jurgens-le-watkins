library(plotly)
library(RColorBrewer)

source("../01 Data/ETL.R")

df2$adult20to29 <- df2$male20to29 + df2$female20to29
df2$youngAdultPercentage <- df2$adult20to29 / df2$TotalPopulation
normalize <- function(x){
  return((x - mean(x)) / sd(x))
}
df2$normalizedIncome <- normalize(df2$PerCapitaIncome)
p <- plot_ly(x = ~list(df2$Avg_InternetUsage), 
             y = ~list(df2$normalizedIncome), 
             z = ~list(df2$youngAdultPercentage),
             marker = list(color = ~mpg, colorscale = c('#FFE1A1', '#683531'), showscale = FALSE), 
             hoverinfo = 'text', 
             text = ~paste('Internet Usage (Avg) : ', df2$Avg_InternetUsage, 
                           '</br>Per Capita Income : ', df2$PerCapitaIncome,
                           '</br> Young Adult Percentage : ', df2$youngAdultPercentage,
                           '</br> State : ', df2$State), color = df2$State) %>% 
             add_markers() %>% 
             layout(scene = list(xaxis = list(title = 'Average Internet Usage'),
                                      yaxis = list(title = 'Median Income'),
                                      zaxis = list(title = 'Young Adult Percentage')))
p
?plot_ly
