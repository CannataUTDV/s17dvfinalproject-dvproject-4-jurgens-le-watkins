#ui.R
require(shiny)
require(shinydashboard)
require(DT)
require(leaflet)
require(plotly)

dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Box Plots", tabName = "boxplot", icon = icon("dashboard")),
      menuItem("Choropleths", tabName = "choropleth", icon = icon("dashboard")),
      menuItem("Scatter Plots", tabName = "scatter", icon = icon("dashboard")),
      menuItem("Barcharts", tabName = "barchart", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"
    ),    
    tabItems(
      # Begin tab content.
      ## -- Boxplot --##
      tabItem(tabName = "boxplot",
              tabsetPanel(
                tabPanel("Data",  
                         radioButtons("rb0", "Get data from:",
                                      c("SQL" = "SQL",
                                        "CSV" = "CSV"), inline=T),
                         uiOutput("states0"), # See http://shiny.rstudio.com/gallery/dynamic-ui.html
                         actionButton(inputId = "click0",  label = "To get data, click here"),
                         hr(), # Add space after button.
                         'Here is data for the boxplots',
                         hr(),
                         DT::dataTableOutput("boxplotData1"),
                         hr()
                ),
                tabPanel("Age Group Distribution", plotlyOutput("boxPlot1", height=700)),
                tabPanel("Internet Usage", plotlyOutput("boxPlot2",height=700)),
                tabPanel("Income Distribution", plotOutput("boxPlot3",height=700))
              )
      ),
      ## -- Choropleth --##
      tabItem(tabName = "choropleth",
              tabsetPanel(
                tabPanel("Data",  
                         radioButtons("rb1", "Get data from:",
                                      c("SQL" = "SQL",
                                        "CSV" = "CSV"), inline=T),
                         uiOutput("states1"), # See http://shiny.rstudio.com/gallery/dynamic-ui.html
                         actionButton(inputId = "click1",  label = "To get data, click here"),
                         hr(), # Add space after button.
                         'Here is data for the choropleths',
                         hr(),
                         DT::dataTableOutput("choroplethData1"),
                         hr()
                ),
                tabPanel("Internet Usage", plotOutput("choroplethPlot1", height=700),plotOutput("choroplethPlot2", height=700))
              )
      ),
      ## -- Scatterplot --##
      tabItem(tabName = "scatter",
              tabsetPanel(
                tabPanel("Data",  
                         radioButtons("rb3", "Get data from:",
                                      c("SQL" = "SQL",
                                        "CSV" = "CSV"), inline=T),
                         uiOutput("states3"), # See http://shiny.rstudio.com/gallery/dynamic-ui.html
                         actionButton(inputId = "click3",  label = "To get data, click here"),
                         hr(), # Add space after button.
                         'Here is data for the scatterplots',
                         hr(),
                         DT::dataTableOutput("scatterplotData1"),
                         hr()
                ),
                tabPanel("Per Capita Income and Average Internet Usage", plotlyOutput("scatterPlot1", height=700)),
                tabPanel("Young Adult and Internet Usage at CoffeeShops", plotlyOutput("scatterPlot2", height=1000, width=1000)),
                tabPanel("Young Population and Internet Usage", plotlyOutput("scatterPlot3", height=1000, width=1000))
              )
      ),
      
      ##--- bar chart tab ---##
      tabItem(tabName = "barchart",
        tabsetPanel(
          tabPanel("Data",  
             radioButtons("rb2", "Get data from:",
                          c("SQL" = "SQL",
                            "CSV" = "CSV"), inline=T),
             uiOutput("states2"), # See http://shiny.rstudio.com/gallery/dynamic-ui.html
             actionButton(inputId = "click2",  label = "To get data, click here"),
             hr(), # Add space after button.
             'Here is data for the bar charts',
             hr(),
             DT::dataTableOutput("barchartData1"),
             hr()
          ),
          tabPanel("Internet Usage", plotOutput("barchartPlot1", height=700)),
          tabPanel("Internet Connectivity", plotlyOutput("barchartPlot2", height=1000, width=1000))
        )
      )
      # End Barchart tab content.
    )
  )
)

