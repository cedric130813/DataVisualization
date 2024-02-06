
# https://rstudio.github.io/shinydashboard/get_started.html

# More on the structure
# https://rstudio.github.io/shinydashboard/structure.html

# load libraries
library(shiny)
library(shinydashboard)

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
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", tabName = "widgets", icon = icon("th"))
  )
)

body = dashboardBody(
  tabItems(
    # First tab content
    tabItem(tabName = "dashboard",
            fluidRow(
              box(plotOutput("plot1", height = 500)),
              box(title = "Controls", sliderInput("slider", 
                                                  "Number of observations:", 10, 100, 50, 5, 
                                                  animate = T)))),
    # Second tab content
    tabItem(tabName = "widgets",
            h2("Widgets tab content"),
            fluidRow(
              # static Valuebox
              valueBox(10 * 2, "New Orders", icon = icon("list")),
              # Dynamic valueBoxes
              valueBoxOutput("progressBox")
            ),
            fluidRow(
              # Clicking this will increment the progress amount
              box(width = 4, actionButton("count", "Increment progress"))
            )
    )
  )
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
  
  output$progressBox <- renderValueBox({
    valueBox(
      paste0(25 + input$count, "%"), "Progress", icon = icon("list"),
      color = "purple"
    )
  })
  
}

shinyApp(ui, server)
# runApp()
