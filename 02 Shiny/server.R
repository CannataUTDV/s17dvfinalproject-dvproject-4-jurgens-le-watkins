# server.R
source("./Required.R")
# run this line in your console to display source code - runApp('GitHub/s17dvfinalproject-dvproject-4-jurgens-le-watkins/02 Shiny',display.mode="showcase")
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
state_list0 <- state_list
state_list1 <- state_list
state_list2 <- state_list
state_list3 <- state_list

##---------Starting Shiny Server Functions-----------------------------------------##

shinyServer(function(input, output) {
  # These widgets are for the BoxPlots tab.
  online0 = reactive({input$rb0})
  output$states0 <- renderUI({selectInput("selectedStates0", "Choose States:", state_list0, multiple = TRUE, selected='All') })
  AvgPoint = reactive({input$UsageRange}) 
  
  # These widgets are for the Choropleth Plots tab.
  online1 = reactive({input$rb1})
  output$states1 <- renderUI({selectInput("selectedStates1", "Choose States:", state_list1, multiple = TRUE, selected='All') })
  UsageLevel= reactive({input$selectedUsageLevels})
  YoungCategory = reactive({input$selectedYoungCategories})
  
  # These widgets are for the Scatter Plots tab.
  online3 = reactive({input$rb3})
  output$states3 <- renderUI({selectInput("selectedStates3", "Choose States:", state_list3, multiple = TRUE, selected='All') })
  
  # These widgets are for the Barcharts tab.
  online2 = reactive({input$rb2})
  output$states2 <- renderUI({selectInput("selectedStates2", "Choose States:", state_list2, multiple = TRUE, selected='All') })
  
  # Begin Box Plot tab ------------------------------------------------------------------
  dfbc0 <- eventReactive(input$click0, {
    if(input$selectedStates0 == 'All') state_list0 <- input$selectedStates0
    else state_list0 <- append(list("Skip" = "Skip"), input$selectedStates0)
    if(online0() == "SQL") {
      print("Getting from data.world")
      tdf = query(
        connection=conn,
        dataset="thule179/s-17-dv-final-project", type="sql",
        query="SELECT State, InternetUsageAtHomeLevel,InternetUsageAtWorkLevel, InternetUsageLevel,InternetUsageAtCoffeeShops , male0to9,male10to19, male20to29,male30to39, male40to49, male50to59, male60to69, male70to79, male80andUp,TenToThirtyK, ThirtyToFiftyK, FiftyToHundredK, HundredToHundredFiftyK, HundredFiftyPlus FROM CleanedInternetUsageByState
        where ?= 'All' or State in (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        queryParameters = state_list0
      ) # %>% View()
    }
    else {
      print("Getting from csv")
      file_path = "CleanedInternetUsageByState.csv"
      df <- readr::read_csv(file_path)
      tdf = df %>% dplyr::filter(State %in% input$selectedStates0 | input$selectedStates0 == "All") # %>% View()
    }
    
  })
  
  dfbc0_v1 <- eventReactive(input$click0_v1, {
    print("Getting from data.world")
    df = query(
        connection = conn,
        dataset="thule179/s-17-dv-final-project", type="sql",
        query="select State, InternetUsageAtHome , InternetUsageAtWork, InternetUsageAtCoffeeShops FROM CleanedInternetUsageByState")
     })
  
  output$boxplotData1 <- renderDataTable({DT::datatable(dfbc0(),
                                                           rownames = FALSE,
                                                           extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
  })
  
  output$boxPlot1 <- renderPlotly({
    df2 <- dfbc0()
    df3 <- data.frame(df2%>%select(State , male0to9,male10to19, male20to29,male30to39, male40to49, male50to59, male60to69, male70to79, male80andUp))
    df3 <- tidyr::gather(df3, ageGroup, number, 2:10)
    
    p1 <- ggplot(df3, aes(x = ageGroup, y = number, color = ageGroup)) + geom_boxplot()
    ggplotly(p1)
    
  })
  output$boxPlot2 <- renderPlotly({
    df2 <- dfbc0_v1()
    df4 <- data.frame(df2%>%select(InternetUsageAtHome, InternetUsageAtWork, InternetUsageAtCoffeeShops))
    df4 <- df4%>%gather( Usage, number, 1:3) 
    df4 <- df4%>%filter(sqrt(number) < AvgPoint())
    
    p2 <- ggplot(df4, aes(x = Usage, y = sqrt(number), color = Usage)) + geom_boxplot()
    ggplotly(p2)
    
  })
  
  output$boxPlot3 <- renderPlot({
    df2 <- dfbc0()
    df5 <- data.frame(df2$TenToThirtyK, df2$ThirtyToFiftyK, df2$FiftyToHundredK, df2$HundredToHundredFiftyK, df2$HundredFiftyPlus)
    
    df5 <- tidyr::gather(df5, Income, number, 1:5)
    
    df5$Income <- factor(df5$Income, levels = c("df2.TenToThirtyK", "df2.ThirtyToFiftyK", "df2.FiftyToHundredK", "df2.HundredToHundredFiftyK", "df2.HundredFiftyPlus"))
    
    p3 <- ggplot(df5, aes(x = Income, y = log(number), color = Income)) + geom_boxplot()
    p3
  })
  # Begin Choropleth Plot tab ------------------------------------------------------------------
  dfbc3 <- eventReactive(input$click1, {
    if(input$selectedStates1 == 'All') state_list1 <- input$selectedStates1
    else state_list1 <- append(list("Skip" = "Skip"), input$selectedStates1)
    if(online1() == "SQL") {
      print("Getting from data.world")
      tdf = query(
        connection=conn,
        dataset="thule179/s-17-dv-final-project", type="sql",
        query="SELECT State, InternetUsageAtHomeLevel,InternetUsageAtWorkLevel, InternetUsageLevel,YoungCategories FROM CleanedInternetUsageByState
        where ?= 'All' or State in (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        queryParameters = state_list1
      ) # %>% View()
    }
    else {
      print("Getting from csv")
      file_path = "CleanedInternetUsageByState.csv"
      df <- readr::read_csv(file_path)
      tdf = df %>% dplyr::filter(State %in% input$selectedStates1 | input$selectedStates1 == "All") # %>% View()
    }
    
  })
  ## --- check boxes of Internet Usage Levels --- ##
  dfbc3_1 <- eventReactive(input$click_v1, {
    print("Getting from data.world")
    print(UsageLevel())
    print(YoungCategory())
    tdf = query(
      connection = conn,
      dataset="thule179/s-17-dv-final-project", type="sql",
      query="select InternetUsageLevel,YoungCategories,State FROM CleanedInternetUsageByState
      where cast(InternetUsageLevel as string) in (?, ?, ?) or cast(YoungCategories as string) in (?,?,?)",
      queryParameters = as.list(UsageLevel(), YoungCategory())
    )
    
  })
  
  output$choroplethData1 <- renderDataTable({DT::datatable(dfbc3(),
                                                            rownames = FALSE,
                                                            extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
  })
  
  output$choroplethPlot1 <- renderPlot({
    df4 <- dfbc3_1()
    df4 <- data.frame(state = df4$State, Young = interaction(df4$InternetUsageLevel, df4$YoungCategories))
    names(df4) <- c("region", "value")
    df4$value <- factor(df4$value)
    df4$region <- tolower(df4$region)
    data("continental_us_states")
    c2 <- state_choropleth(df4, zoom = continental_us_states)
    c2
  })
  
  output$choroplethPlot2 <- renderPlot({
    df3 <- dfbc3()
    df3 <- data.frame(state = df3$State, interaction(df3$InternetUsageAtHomeLevel, df3$InternetUsageAtWorkLevel))
    names(df3) <- c("region", "value")
    df3$value <- factor(df3$value, levels = c("Low.Low", "Low.Medium", "Low.High", "Medium.Low", "Medium.Medium", "Medium.High", "High.Low", "High.Medium", "High.High"))
    df3$region <- tolower(df3$region)
    data("continental_us_states")
    c1 <- state_choropleth(df3,
                           zoom = continental_us_states)
    c1 + scale_fill_brewer(type = "seq", palette = 12)
  })
  
  # Begin ScatterPlot tab ------------------------------------------------------------------
  dfbc2 <- eventReactive(input$click3, {
    if(input$selectedStates3 == 'All') state_list3 <- input$selectedStates3
    else state_list3 <- append(list("Skip" = "Skip"), input$selectedStates3)
    if(online3() == "SQL") {
      print("Getting from data.world")
      tdf = query(
        connection=conn,
        dataset="thule179/s-17-dv-final-project", type="sql",
        query="SELECT State, Avg_InternetUsage,PerCapitaIncome, Avg_InternetUsageAtCoffeeShops,male20to29,female20to29,male10to19,female10to19,TotalPopulation FROM CleanedInternetUsageByState
        where ?= 'All' or State in (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        queryParameters = state_list3
      ) # %>% View()
    }
    else {
      print("Getting from csv")
      file_path = "CleanedInternetUsageByState.csv"
      df <- readr::read_csv(file_path)
      tdf = df %>% dplyr::filter(State %in% input$selectedStates3 | input$selectedStates3 == "All") # %>% View()
    }
    
    
  })
  
  output$scatterplotData1 <- renderDataTable({DT::datatable(dfbc2(),
                                                            rownames = FALSE,
                                                            extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
  })
  
  output$scatterPlot1 <- renderPlotly({
    df2 <- dfbc2()
    p <- plot_ly(df2, x = ~df2$PerCapitaIncome, y = ~df2$Avg_InternetUsage, text = ~df2$State, type = 'scatter', mode = 'markers', size = ~df2$PerCapitaIncome, color = ~State, colors = 'Paired',
                 marker = list(opacity = 0.5, sizemode = 'diameter')) %>%
      layout(title = 'Per Capita Income and Average Internet Usage By State',
             xaxis = list(showgrid = TRUE, title = "Average Internet Usage"),
             yaxis = list(showgrid = TRUE, title = "Per CapitaI ncome"),
             showlegend = FALSE)
    p
  })
  
  output$scatterPlot2 <- renderPlotly({
    df2 <- dfbc2()
    df2$adult20to29 <- df2$male20to29 + df2$female20to29
    p <- plot_ly(x = ~list(df2$Avg_InternetUsage), y = ~list(df2$Avg_InternetUsageAtCoffeeShops), z = ~list(df2$adult20to29),marker = list(color = ~mpg, colorscale = c('#FFE1A1', '#683531'), showscale = FALSE), hoverinfo = 'text', text = ~paste('Internet Usage (Avg): ', df2$Avg_InternetUsage, '</br>Coffee Shops (Avg): ', df2$Avg_InternetUsageAtCoffeeShops,'</br> Young Adult Population: ', df2$adult20to29), color = df2$State) %>%add_markers() %>%layout(scene = list(xaxis = list(title = 'Avg_InternetUsage'),yaxis = list(title = 'CoffeeShops'),zaxis = list(title = 'Young adult')))
    p
    
  })
  
  output$scatterPlot3 <- renderPlotly({
    df2 <- dfbc2()
    young <- df2 %>% select(State,male10to19,male20to29,female10to19,female20to29, TotalPopulation) %>% mutate(youngPerPop = (male10to19+male20to29+female10to19+female20to29)/TotalPopulation) %>% group_by(State)
    plotThing <- ggplot(df2, aes(x = df2$TotalPopulation, y = df2$Avg_InternetUsage )) + geom_point(aes(color = log(df2$TotalPopulation), size = log(TotalPopulation)),position = "jitter")+geom_text(aes(label=df2$State),hjust=2, vjust=-2) +scale_y_log10()+scale_x_log10()
    ggplotly(plotThing)
    
  })
  
  
  # Begin Barchart Tab ------------------------------------------------------------------
  dfbc1 <- eventReactive(input$click2, {
    if(input$selectedStates2 == 'All') state_list2 <- input$selectedStates2
    else state_list2 <- append(list("Skip" = "Skip"), input$selectedStates2)
    if(online2() == "SQL") {
      print("Getting from data.world")
      tdf = query(
        connection=conn,
        dataset="thule179/s-17-dv-final-project", type="sql",
        query="SELECT State, TotalPopulation,InternetUsage,Avg_InternetUsage,NoConnectionAnywhere,NoHomeConnection_ConnectElseWhere,ConnectAtHomeOnly,YoungProportion FROM CleanedInternetUsageByState
        where ?= 'All' or State in (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        queryParameters = state_list2
      ) # %>% View()
    }
    else {
      print("Getting from csv")
      file_path = "CleanedInternetUsageByState.csv"
      df <- readr::read_csv(file_path)
      tdf = df %>% dplyr::filter(State %in% input$selectedStates2 | input$selectedStates2 == "All") # %>% View()
    }
    
    
  })
  
  output$barchartData1 <- renderDataTable({DT::datatable(dfbc1(),
                                                         rownames = FALSE,
                                                         extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
  })
  
  
  output$barchartPlot1 <- renderPlot({
    df <- dfbc1()
    df <- df%>%select(State,Avg_InternetUsage)
    df$InternetUsage_z <-  round((df$Avg_InternetUsage - mean(df$Avg_InternetUsage))/sd(df$Avg_InternetUsage), 2)  # compute normalized Internet Usage
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





