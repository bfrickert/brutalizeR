library(shiny)
source('helper.R')

shinyServer(function(input, output) {
 
  output$banner <- renderImage({
    list(src = './viz/banner.jpg',
         alt = "Measuring Black Metal Brutality",
         width=800)
    
  }, deleteFile = FALSE)
  
  output$brutality.coefs <- renderTable({
    df <- coefs
    df$coef <- as.character(df$coef)
    df[is.na(df$coef),]$coef <- 'Inf.'
    names(df) <- c('index', 'file.name', 'brutality.coefficient')
    select(df, file.name, brutality.coefficient)
  })
  
})