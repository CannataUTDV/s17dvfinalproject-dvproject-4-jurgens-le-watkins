require(choroplethr)

# Map 1 #

df3 <- data.frame(state = df2$State, interaction(df2$InternetUsageAtHomeLevel, df2$InternetUsageAtWorkLevel))
names(df3) <- c("region", "value")
df3$value <- factor(df3$value, levels = c("Low.Low", "Low.Medium", "Low.High", "Medium.Low", "Medium.Medium", "Medium.High", "High.Low", "High.Medium", "High.High"))
names(df3) <- c("Low Home/Low Work Usage", "Low Home/Medium Work Usage", "Low Home/High Work Usage", "Medium Home/Low Work Usage", "Medium Home/Medium Work Usage", "Medium Home/High Work Usage", "High Home/Low Work Usage", "High Home/Medium Work Usage", "High Home/High Work Usage")

df3$region <- tolower(df3$region)
data("continental_us_states")
c1 <- state_choropleth(df3,
                      zoom = continental_us_states)
c1 + scale_fill_brewer(type = "seq", palette = 12)

