#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

#This creates the ui for the app.

ui <- fluidPage(
   
#This creates an application title.
  
   titlePanel("Machine Gun Shots in Springfield MA"),
   
#This creates a sidebar panel describing the animation and the data used. It
#also gives the link to the shotspotter data and this repo.

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

#This defines the server for the app.

server <- function(input, output) {
  
#These create the objects needed for the hyperlinks.
  
  source<- a("here.", href="http://justicetechlab.org/shotspotter-data/")
  
  url <- a("here.", href="https://github.com/camilne9/shotspotter")

#These create the hyperlinks.
  
  output$shotspotter <- renderUI({
    tagList("You can find the complete Shotspotter data", source)})
  
  output$link <- renderUI({
    tagList("You can find the github repository creating this animation", url)})
  
#This renders the gif file containing the animation that we created from the
#script.
  
   output$test <- renderImage(expr = list(src = "springfield.gif"), 
                              deleteFile = FALSE)
}

# This runs the application.

shinyApp(ui = ui, server = server)

