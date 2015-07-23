library(shiny)
library(ggplot2)
library(scales)

source("DataHelper.R", local = T)

## load Activity data
## create a Data Table from the csv file
activityDT <- read.table("data/activity.csv", sep=",", header=T)

## get cleansed data
summaryActivityDT <- getCleansedData(activityDT)

shinyServer(
  function(input, output) {
    breakVal <- reactiveValues()
    breakVal$maj <- "2 hour"
    breakVal$min <- "1 hour"

    observe({
      selVal <- input$n
      if (selVal == "2") {
        breakVal$maj <- "2 hour"
        breakVal$min <- "1 hour"
      }else if (selVal == "4") {
        breakVal$maj <- "4 hour"
        breakVal$min <- "2 hour"
      } else if (selVal == "6") {
        breakVal$maj <- "6 hour"
        breakVal$min <- "3 hour"
      } else if (selVal == "8") {
        breakVal$maj <- "8 hour"
        breakVal$min <- "4 hour"
      }
    })
    
    getActivityData <- function() {
      if (input$plotType == "all") {
        x1 <- summaryActivityDT
      } else if (input$plotType == "wkday") {
        x1 <- summaryActivityDT[summaryActivityDT$weekday=="Weekday",]
      } else if (input$plotType == "wkend") {
        x1 <- summaryActivityDT[summaryActivityDT$weekday=="Weekend",]
      } else if (input$plotType == "adjc") {
        x1 <- summaryActivityDT
      }
    }
    
    output$plot <- renderPlot({
      if (input$plotType == "all") {
        ggplot(data=getActivityData(), aes(x=NewInterval, y=Avg5Mins)) +
        geom_line() + 
        ylab("Average number of steps") + 
        xlab("Recorded at 5 minute Time interval") +
        ggtitle("Time series plot - Personal Activity") + 
        scale_x_datetime(breaks=(breakVal$maj), 
                         minor_breaks=(breakVal$min), 
                         labels = date_format("%H:%M")) 
      } else if (input$plotType == "wkday") {
          ggplot(data=getActivityData(), aes(x=NewInterval, y=Avg5Mins)) +
          geom_line() + 
          ylab("Average number of steps") + 
          xlab("Recorded at 5 minute Time interval") +
          ggtitle("Time series plot - Personal Activity (Weekdays only)") + 
          scale_x_datetime(breaks=(breakVal$maj), 
                           minor_breaks=(breakVal$min),
                           labels = date_format("%H:%M"))
      } else if (input$plotType == "wkend") {
          ggplot(data=getActivityData(), aes(x=NewInterval, y=Avg5Mins)) +
          geom_line() + 
          ylab("Average number of steps") + 
          xlab("Recorded at 5 minute Time interval") +
          ggtitle("Time series plot - Personal Activity (Weekends only)") + 
          scale_x_datetime(breaks=(breakVal$maj), 
                           minor_breaks=(breakVal$min),
                           labels = date_format("%H:%M"))        
      }else if (input$plotType == "adjc") {
          ggplot(data=getActivityData(), aes(x=NewInterval, y=Avg5Mins)) +
          geom_line() + 
          facet_wrap(~weekday, nrow=2)+
          ylab("Average number of steps") +
          xlab("5 minute Time interval") +
          ggtitle("Comparison of Activity between Weekdays and Weekends") + 
          scale_x_datetime(breaks=(breakVal$maj), 
                           minor_breaks=(breakVal$min),
                           labels = date_format("%H:%M")) 
     }
    })
  
  # Generate a summary of the data
  output$summary <- renderPrint({
     summary(getActivityData())
  })
  
  # Generate a string of the data
  output$strval <- renderPrint({
    str(getActivityData())
  })
  
  output$table <- renderDataTable({
    x1 <- getActivityData()
    x1$NewInterval <- format(x1$NewInterval, "%H:%M:%S")
    x1
    })
  }
 
)