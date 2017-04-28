require(ggplot2)
require(tidyr)
df3 <- data.frame(df2$InternetUsageAtHome, df2$InternetUsageAtWork, df2$InternetUsageAtCoffeeShops)
df3 <- tidyr::gather(df3, location, number, 1:3)
ggplot(df3, aes(x = location, y = log(number), color = location)) + geom_boxplot()

# Set working directory to 00 Doc
source("../01 Data/ETL.R")

ggplot(df2) + geom_histogram(aes(x = df2$NoConnectionAnywhere), bins = 1)
