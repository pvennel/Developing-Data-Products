library(plyr)

getCleansedData <- function(activityDT) {
  ## remove NAs
  activityDTNew <- subset(activityDT, activityDT$step != "NA")
  
  ## wday gives numeric weekday (0-Sunday ... 6-Saturday)
  ## so now we have new column with numeric values representing the day of the week
  activityDTNew$dayOfWeek <-as.POSIXlt(as.Date(activityDTNew$date))$wday
  
  ## creating a new field to store weekday/weekend flag
  ## initially set everything to weekday
  activityDTNew$weekday <- "Weekday"
  ## overwrite the rows which is weekend with "weekend"
  activityDTNew$weekday[activityDTNew$dayOfWeek == 0 | activityDTNew$dayOfWeek== 6] <- "Weekend"
  
  ## grouping weekday data by intervals
  activityDTNewSummary <- ddply(activityDTNew, c("interval","weekday"), summarize, 
                                Avg5Mins=sum(steps)/length(steps))
  
  ## This is to handle the gaps as we move from 55 minutes to the hour every hour. 
  ## other wise it will be treated as integer with gap of 45 instead of 5.
  activityDTNewSummary$NewInterval <- strptime(sprintf("%04d", 
                                                       as.numeric(activityDTNewSummary$interval)), 
                                               format="%H%M")
  return(activityDTNewSummary)
}