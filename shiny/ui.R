library(shiny)
source('helper.R')

shinyUI(fluidPage(theme='bootstrap.css',
  
  imageOutput('banner'),
  
  mainPanel(
      br(),br(),br(),br(),br(),br(),br(),br(),
      HTML("<h2 class='XXIIBlackmetalWarrior'>A Satanic Time Series Study of Variance</h2>"),
      HTML("Here is a <span class='XXIIBlackmetalWarrior'>pole cat</span> made of glass."),
      tableOutput('brutality.coefs')
  )
  )
)
