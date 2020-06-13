#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# importing all of the necessary packages for this app
library(shiny)
library(ggplot2)
library(dplyr)
library(stockdat)
library(dygraphs)
library(xts)
library(forecast)
library(lubridate)

# Define server logic required to draw a line graph
shinyServer(function(input, output) {

    # creates the line graph
    output$myPlot <- renderPlot({
      
    # reading in the data from the API
        data <- get_data(from = input$start, to = input$end, stock_symbol = input$company, view_type = input$type, api_key = "Q86JK3PHWQIELR2K")
        
        # need to convert the dates to Date class in order to use scale_x_data
        Date_class <- as.Date(data$Dates)
        
        if(input$type == 1){
          
          ggplot(data, aes(x = Date_class, y = Stock_data, group = 1)) +
            geom_line(color = "DarkGreen") + 
            xlab("Time") +
            ylab("Stock Price") +
            # spreads out the x values and lanels them by their respective months and dates
            scale_x_date(date_breaks = "4 months", date_labels =  "%b %Y") +
            # makes the labels slanted by 45 degrees
            theme_classic() +
            theme(axis.text.x = element_text(angle = -45, vjust = 0)) +
            ggtitle("Open Price of Stock")
        } else if(input$type == 2){
          
          ggplot(data, aes(x = Date_class, y = Stock_data, group = 1)) +
            geom_line(color = "DarkGreen") + 
            xlab("Time") +
            ylab("Stock Prices") +
            # spreads out the x values and lanels them by their respective months and dates
            scale_x_date(date_breaks = "4 months", date_labels =  "%b %Y") +
            # makes the labels slanted by 45 degrees
            theme_classic() +
            theme(axis.text.x = element_text(angle = -45, vjust = 0)) +
            ggtitle("High Price of Stock")
          
        } else if(input$type == 3){
          
          ggplot(data, aes(x = Date_class, y = Stock_data, group = 1)) +
            geom_line(color = "DarkGreen") + 
            xlab("Time") +
            ylab("Stock Prices") +
            # spreads out the x values and lanels them by their respective months and dates
            scale_x_date(date_breaks = "4 months", date_labels =  "%b %Y") +
            # makes the labels slanted by 45 degrees
            theme_classic() +
            theme(axis.text.x = element_text(angle = -45, vjust = 0)) +
            ggtitle("Low Price of Stocks")
        } else if(input$type == 4){
          
          ggplot(data, aes(x = Date_class, y = Stock_data, group = 1)) +
            geom_line(color = "DarkGreen") + 
            xlab("Time") +
            ylab("Stock Prices") +
            # spreads out the x values and lanels them by their respective months and dates
            scale_x_date(date_breaks = "4 months", date_labels =  "%b %Y") +
            # makes the labels slanted by 45 degrees
            theme_classic() +
            theme(axis.text.x = element_text(angle = -45, vjust = 0)) +
            ggtitle("Close Price of Stocks")
        } else if(input$type == 5){
          
          ggplot(data, aes(x = Date_class, y = Stock_data, group = 1)) +
            geom_line(color = "DarkGreen") + 
            xlab("Time") +
            ylab("Shares Traded") +
            # spreads out the x values and lanels them by their respective months and dates
            scale_x_date(date_breaks = "4 months", date_labels =  "%b %Y") +
            # makes the labels slanted by 45 degrees
            theme_classic() +
            theme(axis.text.x = element_text(angle = -45, vjust = 0)) +
            ggtitle("Volume of Stocks")
        }
    })
    
    # second plot
    # must use renderDygraph instead of renderPlot
    output$dygraph <- renderDygraph({
      
      data <- get_data(from = input$start2, to = input$end2, stock_symbol = input$company2, view_type = input$type2, api_key = "Q86JK3PHWQIELR2K")
      
      new_dat <- data %>%
        arrange(Dates)
      
      start_date <- as.Date(new_dat[1,1])
      end_date <- as.Date(new_dat[length(new_dat$Dates), 1])
      
      inds <- seq(start_date, end_date, by = "day")
      
      uni_data <- new_dat %>%
        select(Stock_data)
      
      zoo.obj <- zoo(uni_data, inds)
      
      model = auto.arima(zoo.obj)
      
      predict = forecast(model, h = input$predict) # number of days predicted
      
      predict %>%
        {cbind(actuals=.$x, forecast_mean=.$mean)} %>%
        dygraph()
      
      predict %>%
        {cbind(actuals=.$x, forecast_mean=.$mean,
               lower_95=.$lower[,"95%"], upper_95=.$upper[,"95%"],
               lower_80=.$lower[,"80%"], upper_80=.$upper[,"80%"])} %>%
        dygraph() %>%
        dySeries("actuals", color = "black") %>%
        dySeries(c("lower_80", "forecast_mean", "upper_80"),
                 label = "80%", color = "blue") %>%
        dySeries(c("lower_95", "forecast_mean", "upper_95"),
                 label = "95%", color = "blue") %>%
        dyOptions(drawGrid = input$showgrid)
    })

})
