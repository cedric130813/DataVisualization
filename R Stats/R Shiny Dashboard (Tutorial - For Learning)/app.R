
# https://rstudio.github.io/shinydashboard/get_started.html

# More on the structure
# https://rstudio.github.io/shinydashboard/structure.html

# load libraries
library(shiny)
library(shinydashboard)
library(data.table)
library(tidyverse)
library(hrbrthemes)
library(patchwork)

EduData = read.csv("SPP_compared_to_SPS_Kindergarteners_20240131.csv")

EduData[EduData$Count.of.Children.Served=="<10",3]=10

EduData$Count.of.Children.Served = as.integer(EduData$Count.of.Children.Served) 

EduDataSPP = EduData %>%
  filter(Program.Year == "SPP 2018 - 2019 4 Year-Olds" &
           Group %in% c("White", "Vietnamese", "Two or More Races", "Spanish",
                        "Other Asian Languages", "Other & Unknown Languages",
                        "Native Hawaiian/ Other Pacific Islander", "Male", "Hispanic/ Latino",
                        "Female", "English", "Chinese- All Dialects", "Black/African-American",
                        "Asian", "American Indian/ Alaskan Native", "African Languages")) %>%
  mutate(Group = factor(Group,
                        levels = c("Native Hawaiian/ Other Pacific Islander", 
                                   "American Indian/ Alaskan Native", "Vietnamese", 
                                   "Other & Unknown Languages", "Other Asian Languages", 
                                   "Chinese- All Dialects", "Spanish", "African Languages", 
                                   "Asian", "Hispanic/ Latino", "Black/African-American", 
                                   "Two or More Races", "White", "Female", "Male", "English")))

header = dashboardHeader(title="Cedric's Dashboard",
                         dropdownMenu(
                           type = "tasks", badgeStatus = "success",
                           taskItem(value = 90, color = "green",
                                    "Documentation"
                           ),
                           taskItem(value = 50, color = "blue",
                                    "Project X"
                           ),
                           taskItem(value = 75, color = "yellow",
                                    "Server deployment"
                           ),
                           taskItem(value = 80, color = "black",
                                    "Overall project"
                           )))

#Valid colors are listed in ?validColors

sidebar = dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("gauge")),
    menuItem("Widgets", tabName = "widgets", icon = icon("gauge-simple-high"))
  )
)

body = dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              fluidRow(
                valueBox(100, "New Orders (#)", icon = icon("cart-shopping"),color = "blue"),
                valueBox(350, "Cash ($)", icon = icon("money-bill"),color = "olive")
              ),
              fluidRow(
                width=9,
                box(plotOutput("plot1", height = 200)),
                box(title = "Controls", sliderInput("slider", 
                                                    "Number of observations:", 10, 100, 50, 5, 
                                                    animate = T)),
                # box(plotOutput("plot2", height = 200))),
                box(plotOutput("plot3", height= 400)),
                box(selectInput(
                  inputId = "change_plot",
                  label = "Visualize:",
                  choices = c(
                    "EduVizzers" = "default",
                    "Mt Cars" = "mtcars"
                  ),
                  selected = "default"))
                )),
      # Second tab content
      tabItem(tabName = "widgets",
              h2("Widgets tab content"),
              fluidRow(
                # static Valuebox
                valueBox(100, "New Orders", icon = icon("cart-shopping")),
                # Dynamic valueBoxes
                valueBoxOutput("progressBox")
              ),
              fluidRow(
                # Clicking this will increment the progress amount
                box(width = 4, actionButton("count", "Increment progress"))
              ))
    ),
    tags$head(
        # custom CSS can be inserted here
        # alternatively, refer to http://shiny.rstudio.com/articles/css.html
        tags$style(HTML('
        .main-header .logo {
          font-family: "Arial", "Verdana", "Helvetica", sans-serif;
          font-weight: bold;
          font-size: 16px;
        }
      ')))
)

ui <- dashboardPage(
  header,
  sidebar,
  body,
  skin = "black"
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  output$plot2 = renderPlot({
    plot(mtcars$wt, mtcars$mpg)
  },res = 96)
  
  output$progressBox <- renderValueBox({
    valueBox(
      paste0(25 + input$count, "%"), "Progress", icon = icon("spinner"),
      color = "olive"
    )
  })
  
  plotType <- "bar"
  
  output$plot3 = renderPlot({
    if (input$change_plot %in% "default"){
      ggplot(EduDataSPP,
             aes(x = -Count.of.Children.Served,
                 y = Group,
                 fill = Count.of.Children.Served)) + 
        geom_col(show.legend=FALSE) + labs(subtitle="SPP 2018 - 2019") +
        xlim(-4000, 0) + geom_text(aes(label = Count.of.Children.Served),colour="white")+
        theme_modern_rc() + theme(axis.text.x = element_blank(), 
                                  axis.ticks.x = element_blank(),
                                  axis.title.x = element_blank()) 
    } else { 
      # change to another plot
      # "dynamic parameter"
      ggplot(mtcars, aes(x = factor(cyl), fill = factor(cyl))) +
        geom_bar() +
        labs(title = "Mtcars Plot")
    }
  })
  
  observeEvent(input$changePlotType, {
    if (plotType() == "Bar") {
      plotType("bar")
    } else {
      plotType("scatter")
    }
  })
  
  
}

shinyApp(ui, server)
# runApp()
