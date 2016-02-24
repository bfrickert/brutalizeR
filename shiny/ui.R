library(shiny)
source('helper.R')

shinyUI(fluidPage(theme='bootstrap.css',
  
  imageOutput('banner'),
  
  mainPanel(
      br(),br(),br(),br(),br(),br(),br(),br(),
      HTML("<h2 class='XXIIBlackmetalWarrior'>A Satanic Study of Time Series Variance</h2>"),
      column(12, HTML("<h5>Like most genres of music, Black Metal aspires to deliver
a direct Satanic message. But unlike most other forms of music, it also aspires to being 
unlistenable. This feature of Black Metal is often identified as <strong>brutality</strong>.
But what most interests scientists is whether there exists some way that <strong>the 
sonic brutality of a Black Metal
song can be quantified?</strong><br /><br />And without doubt there doesn't.<br /><br />However, 
if there were a way, it would 
            probably be a measurement of what ratio of an individual black metal song, 
            when blended with <i>Vacation</i> 
            by the 
           <strong>Go-Go's</strong>, alters <i>Vacation</i> so much so that it -- 
statistically speaking -- 
            looks like a black metal 
                      song.</h5>
            <h5>So that means the first question we must answer is
<strong>what does a black metal song look like?</strong><br /><br />
                      It looks like this:</h5>")),
      div(imageOutput('black.metal.looks.like'), style="height:300px;"),
      br(),br(),br(),br(),br(),br(),br(),
      column(12,HTML("<h5>A spikey, black band.</h5>
                     
                     <h5><strong>And what does The Go-Go's <i>Vacation</i> look 
like?</strong><br /><br />
                     Like this:</h5>")),
      div(height=250, imageOutput('vacation.looks.like'), style = "height: 300px;"),
      br(),br(),br(),
      column(12,HTML("<h5>A little different. The topography of the 
<i>Vacation</i> graph includes valleys,
                     not just peaks exclusively.</h5>
           <h5><strong>And what are these data points anyway?</strong> They are the 
numerical representation of 
either song's left channel output. And from these numbers, we can programmatically
                     suss out the amplitude, frequency, even the notes of the 
song segments.</h5>
                     <h5>Check it out.</h5>")),
      div(height=250, imageOutput('satanis.solarfall'), style = "height: 300px;"),
      br(),br(),br(),br(),br(),br(),br(),
      div(height=250, imageOutput('lips.are.sealed'), style = "height: 250px; width: 1000px"),
      column(12,HTML("<h5>And since we have numbers, 
                     we can do math. And this math will sonically alter the songs segments; 
                     effectively,
                     blending them together.<br /><br />Here's the equation!</h5>")),
      div(imageOutput('equation'),style="height:150px;"),
      column(12,HTML("<h5>Where <i>x</i> represents The Go-Go's <i>Vacation</i>,
<i>y</i> is a black metal song and the <strong>brutality coefficient</strong> is represented 
by <strong>Baphomet's goat visage</strong>.<br /><br />Now, it's important to note:
                     the brutality coefficient is indirectly proportional to the 
                     brutality of the song. Therefore, <strong>the more brutal the song,
                     the smaller the brutality coefficient.</strong></h5>")),
      column(12,HTML("<h3>Turning The Go-Go's into <span class='XXIIBlackmetalWarrior'>The Go-Go's</span></h3>")),
      
      column(12,HTML("<h5>Thirty representative black metal songs were selected and ten seconds
                     of each song -- beginning around 30 seconds into the song -- was recorded.
                     The same for thirty Go-Go's songs. The variance of every tenth of a second
of each song's left channel output was computed, and then sampling the distribution of the 
mean of these .1 second variances, the variance difference between the Go-Go's music 
                     and black metal was charted and quantified.</h5>")),
      div(imageOutput('mean.distributions'),style='height:700px'),
      column(12, HTML("<h5>Right away, you may notice that <i>Vacation</i> is a bit of an 
                      outlier from the rest of the samples from the Go-Go's catalog. As
                      a matter of fact, the mean variance of the song falls well within
                      the 95% confidence interval of the distribution of mean variance
                      from all the .1 second black metal samples. However, 
the standard deviation of mean variance of one song, <i>Vacation</i>, is effectively zero, 
so before a
                      Student's T-Test will recognize the mean variance of <i>Vacation</i>
                      as <strong>being equal</strong> to the mean variance of the 
sampled .1 second 
                      black metal samples, it needs to move to the right considerably. 
To do that, we
                      will blend some ratio of a black metal song with <i>Vacation</i>
to make the difference between means zero.
                      That ratio, of course, will be our <strong>brutality coefficient</strong>.
                      <br /><br />
                      Below you can see a list of file names representing 10-second samples of
                      black metal songs next to each song's computed <strong>brutality
                      coefficient</strong>. Behexen's <i>Night of the Blasphemy</i> has the
                      lowest coefficient, and is therefore the most brutal black metal song.</h5>")),
            column(12,HTML("<h5>Check out Watain's <i>Malfeitor</i> -- with a <strong>brutality
                           coefficient</strong> of 0.728879 -- blended with <i>Vacation</i>
                           <a class='XXIIBlackmetalWarrior' href='https://soundcloud.com/lieutenant-beefheart/black-metal-blended-with-the'>here</a>.</h5>")),
            tableOutput('brutality.coefs')
  )
  )
)
