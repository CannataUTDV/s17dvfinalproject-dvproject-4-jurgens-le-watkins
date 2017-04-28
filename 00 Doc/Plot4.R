require(choroplethr)

# Set working directory to 00 Doc.
source("../01 Data/ETL.R")
df3 <- data.frame(state = df2$State, interaction(df2$InternetUsageAtHomeLevel, df2$InternetUsageAtWorkLevel))
names(df3) <- c("region", "value")
df3$value <- factor(df3$value, levels = c("Low.Low", "Low.Medium", "Low.High", "Medium.Low", "Medium.Medium", "Medium.High", "High.Low", "High.Medium", "High.High"))
df3$region <- tolower(df3$region)
data("continental_us_states")
p <- state_choropleth(df3,
                      zoom = continental_us_states)
p + scale_fill_brewer(type = "seq", palette = 12)

?state_choropleth
