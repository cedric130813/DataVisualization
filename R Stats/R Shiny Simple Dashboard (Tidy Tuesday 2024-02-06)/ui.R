#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)



# Define UI for application that draws a histogram
fluidPage(
    theme = bslib::bs_theme(bootswatch = "united"),
    # Application title
    titlePanel("Tidy Tuesday 2024-02-06"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("dotsize",
                        "Dot Size:",
                        min = 5.5,
                        max = 10,
                        value = 8.5,
                        step = 0.5),
            sliderInput("fontsize",
                        "Font Size:",
                        min = 7,
                        max = 15,
                        value = 12,
                        step = 0.5)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("StackedBarChart"),
            plotOutput("ClevelandDotPlot")
        )
    )
)
