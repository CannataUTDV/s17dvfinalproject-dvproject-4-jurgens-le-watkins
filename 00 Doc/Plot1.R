require(plotly)
require(ggplot2)
require(dplyr)
# Set working directory to 00 Doc.
source("../01 Data/ETL.R")
df2 <- df2 %>% arrange(-NoConnectionAnywhere)
df2$State <- factor(df2$State, levels = df2$State[order(df2$NoConnectionAnywhere)])
p <- ggplot(df2) + geom_bar(aes(x = State, y = NoConnectionAnywhere), stat = "identity")
ggplotly(p)