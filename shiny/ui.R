library(shiny)
source('helper.R')

shinyUI(fluidPage(theme='bootstrap.css',
  
  imageOutput('banner'),
  
  mainPanel(
      br(),br(),br(),br(),br(),br(),br(),br(),
      HTML("<h2 class='XXIIBlackmetalWarrior'>A Satanic Study of Time Series Variance</h2>"),
      column(12, HTML("<h5>Is there a way to quantify the sonic <strong>brutality</strong>
            of a black metal song?<br /><br />Chances are there isn't. Nevertheless, if there 
            were a way, it would 
            probably be a measurement of what ratio of an individual black metal song, 
            when blended with <i>Vacation</i> 
            by the 
           <strong>Go-Go's</strong>, alters <i>Vacation</i> so much so that it -- statistically speaking -- 
            becomes a black metal 
                      song.</h5>
            <h5>And what does a black metal song -- statistically speaking -- look like?</h5>")),
      tableOutput('brutality.coefs')
  )
  )
)
