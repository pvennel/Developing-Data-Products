library(shiny)

shinyUI(fluidPage(
  
  #Application title
  titlePanel("Daily Activity"),
  
  sidebarLayout(
    sidebarPanel(
        radioButtons("plotType", "Type of Day:",
                   c("All" = "all",
                     "Weekday" = "wkday",
                     "Weekend" = "wkend",
                     "Both - adjacent" = "adjc")),
                    
        br(),
      
        sliderInput("n", "Displayed time Interval (hours):",
                  value =2,
                  min = 2,
                  step=2,
                  max = 8),
        
        includeHTML("include.html")
    ),
    
    # Show a tabset that includes a plot, summary, and table view
    # of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Plot", plotOutput("plot")), 
                  tabPanel("Summary", verbatimTextOutput("summary")),
                  tabPanel("String Value", verbatimTextOutput("strval")), 
                  tabPanel("Table", dataTableOutput("table"))
      )
    )
  )
))
