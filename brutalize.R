library(pacman)
p_load(tuneR, zoo)

get.matrix <- function(f, dir='wavs/black/', t='black'){
  sndObj <- readWave(paste(dir,'/',f,sep=''))
  s1 <- sndObj@left
  s1 <- s1 / 2^(sndObj@bit -1)
  
  metal.df <- data.frame(s1)
  file.name <- gsub('.wav','', f)
  write.table(metal.df, paste('matrices/', t, '/', file.name,'.array.csv',sep=''), row.names = F, sep=',', col.names = F)
}

black.files <- list.files('wavs/black')
sapply(black.files, function(x){
  get.matrix(x, dir='wavs/black',t='black')
})

death.files <- list.files('wavs/death')
sapply(death.files, function(x){
  get.matrix(x, dir='wavs/death',t='death')
})

gogos.files <- list.files('wavs/gogos')
sapply(gogos.files, function(x){
  get.matrix(x, dir='wavs/gogos',t='gogos')
})

files <- list.files('wavs/vacation')
sapply(files, function(x){
  get.matrix(x, dir='wavs/vacation',t='vacation')
})


create.new.files <- function(x){
  s <- seq(from=.25, to=10, by=.25)
  
  file.name <- paste('wavs/newfiles/', gsub('.wav','',x), sep='')
  print(file.name)
  black <- readWave(paste('wavs/black/',x,sep=''))
  #black <- readWave('wavs/black/1349.godslayer.wav')
  vacation <- readWave('wavs/vacation/vacation.wav')
  
  minimum <- min(length(black@left), length(vacation@left))
  
  s1 <- black@left[1:minimum]
  s2 <- vacation@left[1:minimum]
  
  all <- merge(black.metal=as.zoo(ts(s1,start=1)), vacation=as.zoo(ts(s2,start=1)))
  
  df<- data.frame(all)
  
  diff.black <- ts(with(df[complete.cases(df),], vacation + (as.numeric(i)*black.metal)), frequency=vacation@samp.rate, start=1)
  
  
  sub.function <- function(i, f.name, db){
    fit <- stl(db, s.window="periodic", robust=F)
    fcast <- forecast(fit, method="ets", h=100)
    print(i)
    f <- paste(f.name,'.',i,'.wav',sep='')
    print(f)
    savewav(as.vector(fcast$fitted), f=black@samp.rate, filename=f)
  }
  sapply(s,function(x){sub.function(x,file.name,diff.black)})
}

sapply(black.files[1],create.new.files) 

files <- list.files('wavs/newfiles')
sapply(files, function(x){
  get.matrix(x, dir='wavs/newfiles',t='newfiles')
})