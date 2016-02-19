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
            looks like a black metal 
                      song.</h5>
            <h5>And what does a black metal song look like?</h5>")),
      imageOutput('black.metal.looks.like'),
      column(12,HTML("<h5>And what does <i>Vacation</i> look like?</h5>")),
      imageOutput('vacation.looks.like'),
      HTML("The first thing you may notice is that the black metal song's data has far more
           variance. The observations are spread between 15000 and -15000 across the graph, 
           forming a black band occupying most of the chart. <i>Vacation</i>, on the other
           hand, varies between 3000 and -3000, with spans in which the observations
           vary far less."),
      column(12,HTML("<h3>Turning The Go-Go's into <span class='XXIIBlackmetalWarrior'>The Go-Go's</span></h4>")),
      tableOutput('brutality.coefs')
  )
  )
)
