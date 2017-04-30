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
      menuItem("Barcharts, Table Calculations", tabName = "barchart", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"
    ),    
    tabItems(
      # Begin tab content.
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
                tabPanel("Young Adult and Internet Usage at CoffeeShops", plotlyOutput("scatterPlot2", height=1000, width=1000))
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

