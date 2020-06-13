#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(dygraphs)

# Define UI for application that draws a time series graph
# navbarPage lets me make different pages on the shiny app by using tabPanel
shinyUI(navbarPage(

    # Application title
   "Time Series for Stock Data",
    
    # applies a theme to the shiny app using shinythemes package
    theme = shinytheme("flatly"),
   
    # first tab panel
    tabPanel("Time Series Plot",
    # Sidebar inputs
    sidebarLayout(
        sidebarPanel(
            # first argument is the name of the input(doesn't really matter i guess)
            # the second argument is the title of the input that you will see
            textInput("company", 
                        label = "Enter a company stock symbol:",
                        "IBM"),
            dateInput("start", 
                           label = "Enter start date for your analysis:",
                           value = "2015-05-26"),
            dateInput("end", 
                      label = "Enter end date for your analysis:",
                      value = "2020-06-02"),
            numericInput("type",
                        label = "Enter Type of Stock Data (1-5):",
                        value = 1)
        ),

        # Shows first plot from server file
        mainPanel(
            plotOutput("myPlot"))
        )
      ),
   
   # second tab panel
   tabPanel("Forcast Plot",
            sidebarLayout(
              sidebarPanel(
                # first argument is the name of the input(doesn't really matter i guess)
                # the second argument is the title of the slider or select input that you will see
                textInput("company2", 
                          label = "Enter a company stock symbol:",
                          "IBM"),
                dateInput("start2", 
                          label = "Enter start date for your analysis:",
                          value = "2017-05-26"),
                dateInput("end2", 
                          label = "Enter end date for your analysis:",
                          value = "2020-06-02"),
                numericInput("type2",
                             label = "Enter Type of Stock Data (1-5):",
                             value = 1),
                checkboxInput("showgrid", label = "Show Grid", value = TRUE),
                numericInput("predict",
                             label = "Enter number of days to predict:",
                             value = 30),
              ),
              
              # Shows second plot from server file
              mainPanel(
              # need to use dygraphOutput because it is interactive and from a special package
                dygraphOutput("dygraph"))
            )
      )
  )
)
