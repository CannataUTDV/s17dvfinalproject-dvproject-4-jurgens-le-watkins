# server.R
source("./Required.R")

online0 = TRUE

# Server.R structure:
#   Queries that don't need to be redone
#   shinyServer
#   widgets
#   tab specific queries and plotting

if(online0) {
  states = query(
    connection=conn,
    dataset="thule179/s-17-dv-final-project", type="sql",
    query="SELECT State FROM CleanedInternetUsageByState"
  ) # %>% View()
} else {
  print("Getting States from csv")
  file_path = "CleanedInternetUsageByState.csv"
  df <- readr::read_csv(file_path) 
  states = df$State
}
state_list <- as.list(states$State)
state_list <- append(list("All" = "All"), state_list)
state_list5 <- state_list

##---------Starting Shiny Server Functions-----------------------------------------##

shinyServer(function(input, output) { 
# These widgets are for the Barcharts tab.
online2 = reactive({input$rb2})
output$states2 <- renderUI({selectInput("selectedStates", "Choose States:", state_list, multiple = TRUE, selected='All') })
# Begin Barchart Tab ------------------------------------------------------------------
dfbc1 <- eventReactive(input$click2, {
  if(input$selectedStates == 'All') state_list <- input$selectedStates
  else state_list <- append(list("Skip" = "Skip"), input$selectedStates)
  if(online2() == "SQL") {
    print("Getting from data.world")
    tdf = query(
      connection=conn,
      dataset="thule179/s-17-dv-final-project", type="sql",
      query="SELECT State, TotalPopulation,InternetUsage,NoConnectionAnywhere,NoHomeConnection_ConnectElseWhere,ConnectAtHomeOnly,YoungProportion FROM CleanedInternetUsageByState
      where ?= 'All' or State in (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
      queryParameters = state_list
    ) # %>% View()
  }
  else {
    print("Getting from csv")
    file_path = "CleanedInternetUsageByState.csv"
    df <- readr::read_csv(file_path)
    tdf = df %>% dplyr::filter(State %in% input$selectedStates | input$selectedStates == "All") # %>% View()
  }
  

})

output$barchartData1 <- renderDataTable({DT::datatable(dfbc1(),
                                                       rownames = FALSE,
                                                       extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
})


output$barchartPlot1 <- renderPlot({
  df <- dfbc1()
  df <- df%>%select(State,InternetUsage)
  df$InternetUsage_z <-  round((df$InternetUsage - mean(df$InternetUsage))/sd(df$InternetUsage), 2)  # compute normalized Internet Usage
  df$InternetUsage_type <- ifelse(df$InternetUsage_z < 0, "below", "above")  # above / below avg flag
  df <- df[order(df$InternetUsage_z), ]  # sort
  df$State <- factor(df$State, levels = df$State) 
  
  InternetUsage_bar <- ggplot(df, aes(x=State, y=InternetUsage_z, label=InternetUsage_z)) + geom_bar(stat='identity', aes(fill=InternetUsage_type), width=.5)  +scale_fill_manual(name="Internet Usage", labels = c("Above Average", "Below Average"), values = c("above"="#00ba38", "below"="#f8766d")) + coord_flip()
  
  InternetUsage_bar
})

output$barchartPlot2 <- renderPlotly({
  df <- dfbc1()
  df <- df[order(df$TotalPopulation),]
  df <- df%>%select(State,TotalPopulation,NoConnectionAnywhere,NoHomeConnection_ConnectElseWhere,ConnectAtHomeOnly)
  df_all <- df%>%gather("Connection", Connection_Percentage,3:5,-TotalPopulation)
  plot1 <- ggplot(df_all,aes(x = Connection, y = Connection_Percentage, fill = Connection)) + geom_bar(stat = "identity", color = "black") + coord_flip() + labs(y = "Connectivity", x = "State", color = "Percentage") + theme(axis.text = element_text(size = 3)) + facet_wrap(~State) + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .25)) + scale_fill_brewer(palette="RdPu")
  plot1
})
})





