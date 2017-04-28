require(ggplot2)
require(tidyr)
require(plotly)


# Set working directory to 00 Doc
source("../01 Data/ETL.R")

# Boxplot 1 #
df3 <- data.frame(df2$State, df2$male0to9, df2$male10to19, df2$male20to29, df2$male30to39, df2$male40to49, df2$male50to59, df2$male60to69, df2$male70to79, df2$male80andUp)

df3 <- tidyr::gather(df3, ageGroup, number, 2:10)

p1 <- ggplot(df3, aes(x = ageGroup, y = number, color = ageGroup)) + geom_boxplot()
ggplotly(p1)


# Boxplot 2 #
df4 <- data.frame(df2$InternetUsageAtHome, df2$InternetUsageAtWork, df2$InternetUsageAtCoffeeShops)
df4 <- tidyr::gather(df4, Usage, number, 1:3)

p2 <- ggplot(df4, aes(x = Usage, y = sqrt(number), color = Usage)) + geom_boxplot()
ggplotly(p2)

# Boxplot 3 #
df5 <- data.frame(df2$TenToThirtyK, df2$ThirtyToFiftyK, df2$FiftyToHundredK, df2$HundredToHundredFiftyK, df2$HundredFiftyPlus)
df5 <- tidyr::gather(df5, Income, number, 1:5)
df5$Income <- factor(df5$Income, levels = c("df2.TenToThirtyK", "df2.ThirtyToFiftyK", "df2.FiftyToHundredK", "df2.HundredToHundredFiftyK", "df2.HundredFiftyPlus"))
p3 <- ggplot(df5, aes(x = Income, y = log(number), color = Income)) + geom_boxplot()

## TODO : Would like to add State to hover info on these box plots!
