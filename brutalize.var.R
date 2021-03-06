library(pacman)
p_load(tuneR, zoo, seewave, phonTools)

var.each.sec <- function(f, dir='wavs/black'){
  sndObj <- readWave(paste(dir,'/',f,sep=''))

  s<-seq(from=1, to=100, by=1)
  print(f)
  sub.function <- function(i){
    samp.rate <- 44100/10
    return(var(sndObj@left[(((i-.2)*samp.rate)+1):(i*samp.rate)]))
  }
  return(sapply(s, sub.function))
 #return(na.omit(rollapply(diff.black, width = 4410, FUN = var, fill = NA)))
}

black.files <- list.files('wavs/black')
black.list <- lapply(black.files, function(x){
  var.each.sec(x)
})
gogo.files <- list.files('wavs/gogos')
gogo.list <- lapply(gogo.files, function(x){
  var.each.sec(x, dir='wavs/gogos')
})

var.each.file <- function(f, dir='wavs/black'){
  sndObj <- readWave(paste(dir,'/',f,sep=''))
  return(var(sndObj@left))
}
vars <-sapply(gogo.files, function(x){
  var.each.file(x,dir='wavs/gogos')
})

set.seed(666)
black.samples <- replicate(100000, mean(sample(unlist(black.list),100,replace = F)))
gogo.samples <- replicate(100000, mean(sample(unlist(gogo.list),100,replace = F)))
par(mfrow=c(2,1))
hist(black.samples )
hist(gogo.samples)
par(mfrow=c(1,1))

(test.t <-t.test(black.samples,gogo.samples))
test.t$p.value

p.value <-0
brutality.coef <- 0

calculate.brutality <- function(f){
  s <- seq(from=100.99, to=200, by=.000001)
  black.metal <- readWave(paste('wavs/black/', f, sep=''))
  
  vacation <- readWave('wavs/vacation/vacation.wav')
  
  minimum <- min(length(black.metal@left), length(vacation@left))
  
  s1 <- black.metal@left[1:minimum]
  s2 <- vacation@left[1:minimum]
  
  all <- merge(black.metal=as.zoo(ts(s1,start=1)), vacation=as.zoo(ts(s2,start=1)))
  
  df<- data.frame(all)
  
  sub.function <- function(n){
    
    diff.black <- ts(with(df[complete.cases(df),], vacation + (as.numeric(n)*black.metal)), frequency=vacation@samp.rate, start=1)
    
    savewav(diff.black, f=44100, filename='wavs/newfiles/new.wav')
    black.metal.list <- var.each.sec('new.wav', dir='wavs/newfiles')
    black.metal.samples <- replicate(100000, mean(sample(unlist(black.metal.list),100,replace = F)))
    print(as.character(n))
    print(mean(black.metal.samples))
    print(mean(black.samples))
    (ttest <- t.test(black.metal.samples, black.samples))
    print(ttest$p.value)
    if (ttest$p.value >= 0.05) {
      print(ttest$p.value)
      brutality.coef <<- n
      stop("goddammit")
    }
  }
  sapply(s, sub.function)
}

calculate.brutality(black.files)
