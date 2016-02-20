library(shiny)
source('helper.R')

shinyServer(function(input, output) {
 
  output$banner <- renderImage({
    list(src = './viz/banner.jpg',
         alt = "Measuring Black Metal Brutality",
         width=800)
    
  }, deleteFile = FALSE)
  
  output$vacation.looks.like <- renderImage({
    list(src = './viz/vacation.looks.like.png',
         alt = "10 secs of 'Vacation'",
         width=400,
         height=250)
    
  }, deleteFile = FALSE)
  
  output$black.metal.looks.like <- renderImage({
    list(src = './viz/black.metal.looks.like.png',
         alt = "10 secs of Black Metal",
         width=400,
         height=250)
    
  }, deleteFile = FALSE)
  
  output$satanis.solarfall <- renderImage({
    list(src = './viz/satanis.solarfall.png',
         alt = "Satanis Solarfall",
         width=400,
         height=250)
    
  }, deleteFile = FALSE)
  
  output$lips.are.sealed <- renderImage({
    list(src = './viz/lips.are.sealed.png',
         alt = "Lips Are Sealed Melody",
         width=400,
         height=250)
    
  }, deleteFile = FALSE)
  
  output$brutality.coefs <- renderTable({
    df <- coefs
    df$coef <- as.character(df$coef)
    df[is.na(df$coef),]$coef <- 'Inf.'
    names(df) <- c('index', 'file.name', 'brutality.coefficient')
    select(df, file.name, brutality.coefficient)
  })
  
})