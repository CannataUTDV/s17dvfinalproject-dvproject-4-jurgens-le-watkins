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
      # Begin Barchart tab content.
      tabItem(tabName = "barchart",
        tabsetPanel(
          tabPanel("Data",  
             radioButtons("rb2", "Get data from:",
                          c("SQL" = "SQL",
                            "CSV" = "CSV"), inline=T),
             uiOutput("states2"), # See http://shiny.rstudio.com/gallery/dynamic-ui.html
             actionButton(inputId = "click2",  label = "To get data, click here"),
             hr(), # Add space after button.
             'Here is data for the "Barchart with Table Calculation" tab',
             hr(),
             DT::dataTableOutput("barchartData1"),
             hr()
          ),
          tabPanel("Barchart with Table Calculation", "Black = Sum of Sales per Region, Red = Average Sum of Sales per Category, and  Blue = (Sum of Sales per Region - Average Sum of Sales per Category)", plotOutput("barchartPlot1", height=1500)),
          tabPanel("High Discount Orders", leafletOutput("barchartMap1"), height=900 ),
          tabPanel("High Sales Customers", plotlyOutput("barchartPlot2", height=700) )
        )
      )
      # End Barchart tab content.
    )
  )
)

