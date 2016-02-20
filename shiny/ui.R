library(shiny)
source('helper.R')

shinyUI(fluidPage(theme='bootstrap.css',
  
  imageOutput('banner'),
  
  mainPanel(
      br(),br(),br(),br(),br(),br(),br(),br(),
      HTML("<h2 class='XXIIBlackmetalWarrior'>A Satanic Study of Time Series Variance</h2>"),
      column(12, HTML("<h5>Is there a way to quantify the sonic <strong>brutality</strong>
            of a black metal song?<br /><br />Chances are there isn't.<br /><br />However, if there 
            were a way, it would 
            probably be a measurement of what ratio of an individual black metal song, 
            when blended with <i>Vacation</i> 
            by the 
           <strong>Go-Go's</strong>, alters <i>Vacation</i> so much so that it -- statistically speaking -- 
            looks like a black metal 
                      song.</h5>
            <h5>And what does a black metal song look like?</h5>")),
      div(imageOutput('black.metal.looks.like'), style="height:300px;"),
      br(),br(),br(),br(),
      column(12,HTML("<h5>It looks like a spikey, black band.</h5>
                     
                     <h5>And what does <i>Vacation</i> look like?</h5>")),
      div(height=250, imageOutput('vacation.looks.like'), style = "height: 300px;"),
      br(),
      column(12,HTML("<h5>A little different. The data points of the <strong>Burzum</strong>
           song segment are spread between 15000 and -15000 across the entire graph, whereas 
<i>Vacation</i>, 
           on the other
           hand, varies between 3000 and -3000. What's more, the topography of the 
<i>Vacation</i> graph includes valleys,
                     not just peaks exclusively.</h5>
           <h5>And what are these data points? They are the numerical representation of 
either song's left channel output. And from these numbers, we can programmatically
                     determine amplitude, frequency, even the notes of the song segments.</h5>
                     <h5>Check it out.</h5>")),
      div(height=250, imageOutput('satanis.solarfall'), style = "height: 300px;"),
      br(),br(),br(),br(),br(),br(),br(),
      div(height=250, imageOutput('lips.are.sealed'), style = "height: 300px; width: 1000px"),
      column(12,HTML("<h3>Turning The Go-Go's into <span class='XXIIBlackmetalWarrior'>The Go-Go's</span></h4>")),
      column(12,HTML("<h5>Since we have numbers representing either channel, that means
                     we can do math. And this math will sonically alter the songs; effectively,
                     blending them together.</h5>")),
      
      tableOutput('brutality.coefs')
  )
  )
)
