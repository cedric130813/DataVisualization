# Library
library(dygraphs)
library(xts)          # To make the conversion data-frame / xts format
library(tidyverse)
library(lubridate)

AirP = AirPassengers
class(as.Date.ts(AirP))

library(timeplyr)
AirP = ts_as_tibble(AirP)

AirP$time = as.Date.ts(AirPassengers)

# library(clock)
# library(lubridate)

AirP_Dy <- xts(x = AirP$value, order.by = AirP$time)

p <- dygraph(AirP_Dy) %>%
  dyOptions(labelsUTC = TRUE, 
            fillGraph=TRUE, 
            fillAlpha=0.1, 
            drawGrid = FALSE, colors="blue") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.2, hideOnMouseOut = FALSE)  %>%
  dyRoller(rollPeriod = 1)

p
