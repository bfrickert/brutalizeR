library(pacman)
p_load(tuneR)

get.matrix <- function(f, dir='wavs/black/', t='black'){
  sndObj <- readWave(paste(dir,'/',f,sep=''))
  Wobjm <- mono(sndObj, "left") # extract the left channel
  # and downsample to 11025 samples/sec.:
  Wobjm11 <- downsample(Wobjm, sndObj@samp.rate)
  # extract a part of the signal interactively (click for left/right limits):
  
  ## Not run:
  #Wobjm11s <- extractWave(Wobjm11)
  ## End(Not run)
  
  # or extract some values reproducibly
  Wobjm11s <- extractWave(Wobjm11, from=0, to=1000000)
  
  # calculating periodograms of sections each consisting of 1024 observations,
  # overlapping by 512 observations:
  WspecObject <- periodogram(Wobjm11s, normalize = TRUE, width = 1024, overlap = 512)
  # Let's look at the first periodogram:
  plot(WspecObject, xlim = c(0, 2000), which = 1)
  # or a spectrogram
  image(WspecObject, ylim = c(0, 1000))
  # calculate the fundamental frequency:
  ff <- FF(WspecObject)
  print(ff)
  # derive note from FF given diapason a'=440
  notes <- noteFromFF(ff, 440)
  # smooth the notes:
  snotes <- smoother(notes)
  # outcome should be 0 for diapason "a'" and -12 (12 halftones lower) for "a"
  print(snotes)
  #snotes <- na.omit(snotes)
  notenames(na.omit(snotes), language = 'english')
  # plot melody and energy of the sound:
  m <- melodyplot(WspecObject, snotes)
  m$notenames
  
  # apply some quantization (into 8 parts):
  #qnotes <- quantize(snotes[!is.na(snotes)], WspecObject@energy[!is.na(snotes)], parts = 40000)
  snotes[is.na(snotes)] <- 0
  metal.df <- data.frame(snotes, WspecObject@energy)
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
  s <- seq(from=1, to=40, by=1)
  
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