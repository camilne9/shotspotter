#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Machine Gun Shots in Springfield MA"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
     sidebarPanel(
       h4("Description:"),
p("This animation uses Shotspotter data 
from Springfield MA to examine the 
                    location of machine gun shots in Springfield between 2008 and 2018. 
                    Thank you to Justice Tech Lab for making the data used in creating this plot available."),
uiOutput("shotspotter"),
h4("Github:"),
uiOutput("link"),
h3("Creator:"),
h4("Christopher Milne")
     ),
      
      # Show a plot of the generated distribution
      mainPanel(
         imageOutput("test")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  source<- a("here.", href="http://justicetechlab.org/shotspotter-data/")
  
  url <- a("here.", href="https://github.com/camilne9/shotspotter")
  
  output$shotspotter <- renderUI({
    tagList("You can find the complete Shotspotter data", source)})
  
  output$link <- renderUI({
    tagList("You can find the github repository creating this animation", url)})
  
   output$test <- renderImage(expr = list(src = "springfield.gif"), 
                              deleteFile = FALSE)
}

# Run the application 
shinyApp(ui = ui, server = server)

