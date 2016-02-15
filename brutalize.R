library(pacman)
p_load(tuneR)

get.matrix <- function(f, dir='wavs/black/', t='black'){
  sndObj <- readWave(paste(dir,'/',f,sep=''))
  s1 <- sndObj@left
  s1 <- s1 / 2^(sndObj@bit -1)
  
  metal.df <- data.frame(s1)
  file.name <- gsub('.wav','', f)
  write.table(metal.df, paste('matrices/', t, '/', file.name,'.array.csv',sep=''), row.names = F, sep=',', col.names = F)
}

files <- list.files('wavs/black')
sapply(files, function(x){
  get.matrix(x, dir='wavs/black',t='black')
})

files <- list.files('wavs/death')
sapply(files, function(x){
  get.matrix(x, dir='wavs/death',t='death')
})

files <- list.files('wavs/gogos')
sapply(files, function(x){
  get.matrix(x, dir='wavs/gogos',t='gogos')
})

files <- list.files('wavs/vacation')
sapply(files, function(x){
  get.matrix(x, dir='wavs/vacation',t='vacation')
})
