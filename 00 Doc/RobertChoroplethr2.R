# Map 2 #

df4 <- data.frame(state = df2$State, Young = interaction(df2$InternetUsageLevel, df2$YoungCategories))
df4
df4$Young <- factor(df4$Young, levels = c("Low.Low", "Low.Medium", "Low.High", "Medium.Low", "Medium.Medium","Medium.High","High.Low","High.Medium", "High.High"))

levels(df4$Young) <- c("Few Young People/Low Internet Access", "Average Young People/Low Internet Access", "Many Young People/Low Internet Access", "Few Young People/Average Internet Access", "Average Young People/Average Internet Access", "Many Young People/Average Internet Access", "Few Young People/High Internet Access", "Average Young People/High Internet Access", "Many Young People/Low Internet Access")

names(df4) <- c("region", "value")
df4$value <- factor(df4$value)
df4$region <- tolower(df4$region)

c2 <- state_choropleth(df4,
                       zoom = continental_us_states)
c2
