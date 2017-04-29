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
})


