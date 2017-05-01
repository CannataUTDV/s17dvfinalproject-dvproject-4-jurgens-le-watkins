# Map 2 #

df4 <- data.frame(state = df2$State, Young = interaction(df2$InternetUsageLevel, df2$YoungCategories))
names(df4) <- c("region", "value")
df4$value <- factor(df4$value)
df4$region <- tolower(df4$region)

c2 <- state_choropleth(df4,
                       zoom = continental_us_states)
c2
