require(plotly)
require(dplyr)
require(tidyr)
require(RColorBrewer)

# Set working directory to 00 Doc.
source("../01 Data/ETL.R")

# plot #1 - top 6 states by population and internet connectivity
# select top 6 States by Population
df <- df2[order(df2$TotalPopulation),]
df <- df%>%select(State,TotalPopulation,NoConnectionAnywhere,NoHomeConnection_ConnectElseWhere,ConnectAtHomeOnly)
df_top <- df[1:6,]
df_top <- df_top%>%gather("Connection",Connection_Percentage,3:5,-TotalPopulation)

plot1 <- plot_ly(x = df_top$Connection, y = df_top$Connection_Percentage, color = ~df_top$State)%>%layout( title = "Top 6 States Average Connectivity")
plot1

# plot #2 - shows internet connectivity for every state - facet_wrap
df_all <- df%>%gather("Connection", Connection_Percentage,3:5,-TotalPopulation)
plot2 <- ggplot(df_all,aes(x = Connection, y = Connection_Percentage, fill = Connection)) + geom_bar(stat = "identity", color = "black") + coord_flip() + labs(y = "Connectivity", x = "State", color = "Percentage") + theme(axis.text = element_text(size = 3)) + facet_wrap(~State) + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .25)) + scale_fill_brewer(palette="RdPu")
plot2

# plot #3 - Diverging bar chart - Internet Usage
df3 <- df2%>%select(State,Avg_InternetUsage)
df3$InternetUsage_z <-  round((df3$Avg_InternetUsage - mean(df3$Avg_InternetUsage))/sd(df3$Avg_InternetUsage), 2)  # compute normalized Internet Usage
df3$InternetUsage_type <- ifelse(df3$InternetUsage_z < 0, "below", "above")  # above / below avg flag
df3 <- df3[order(df3$InternetUsage_z), ]  # sort
df3$State <- factor(df3$State, levels = unique(df3$State)[order(df3$InternetUsage_z)]) 
                  
InternetUsage_bar <- ggplot(df3, aes(x=State, y=InternetUsage_z, label=InternetUsage_z)) + geom_bar(stat='identity', aes(fill=InternetUsage_type), width=.5)  +scale_fill_manual(name="Internet Usage", labels = c("Above Average", "Below Average"), values = c("above"="#00ba38", "below"="#f8766d")) + coord_flip()
InternetUsage_bar

# plot #4 - Diverging bar chart - Young People Proportion
df4 <- df2%>%select(State,YoungProportion)
df4$YoungPeople_z <-  round((df4$YoungProportion - mean(df4$YoungProportion))/sd(df4$YoungProportion), 2)  # compute normalized Young Proportion
df4$YoungPeople_type <- ifelse(df4$YoungPeople_z < 0, "below", "above")  # above / below avg flag
df4 <- df4[order(df4$YoungPeople_z), ]  # sort
df4$State <- factor(df4$State, levels = df4$State) 
df5 <- df4[df4$State %in% c("Vermont", "New Hampshire", "Minnesota", "Mississippi", "Alabama", "Tennessee"),]

YoungPeople_bar <- ggplot(df5, aes(x=State, y=YoungPeople_z, label=YoungPeople_z)) + geom_bar(stat='identity', aes(fill=YoungPeople_type), width=.5)  +scale_fill_manual(name="Young Proportion", labels = c("Above Average", "Below Average"), values = c("above"="#00ba38", "below"="#f8766d")) + coord_flip()
YoungPeople_bar


