library(pacman)
p_load(tuneR, seewave, dplyr, forecast, audio, phonTools,xts,zoo,lubridate, dygraphs, lmtest)

get.wav <- function(x){
  return(readWave(x))
}

setwd('wavs/black')
files <- list.files()
black.wavs <- sapply(files, get.wav)
setwd('../../')

watain <- black.wavs["watain.malfeitor.wav"][[1]]
satyricon <- black.wavs["satyricon.medievel.wav"][[1]]
satyricon <- black.wavs["judas.iscariot.hateful.visions.wav"][[1]]
s1 <- watain@left[ceiling(length(watain@left)/2):length(watain@left)]
s2 <- satyricon@left[length(s1):ceiling(length(s1)/2)]
s3 <- c(s2, s1)


s1.x <- as.xts(ts(s1,start=c(1)))
s2.x <- as.xts(ts(s2, start=c(1)))
s3.mrg <- merge(s1.x, s2.x)
head(s3.mrg)

all <- merge(watain=as.zoo(ts(watain@left,start=c(1))), satyricon=as.zoo(ts(satyricon@left,start=1)))

df<- data.frame(all)

#SOMEHOW A a coefficient of metal must be calculated!!!!!

diff.black <- ts(with(df[complete.cases(df),], watain - (satyricon*1) - sample(1:2053,nrow(df[complete.cases(df),]),replace = T)), frequency=watain@samp.rate, start=1)
#diff.black <- ts(rep(2000,200000), frequency=1000, start=1)

#a.ts <- ts(s3, frequency=1000, start=c(1))

fit <- stl(diff.black, s.window="periodic", robust=F)
fcast <- forecast(fit, method="ets", h=100)
playsound(watain@left, path='/usr/bin/vlc', fs=watain@samp.rate)
playsound(satyricon@left, path='/usr/bin/vlc', fs=watain@samp.rate)
playsound(as.vector(diff.black), path='/usr/bin/vlc',fs=watain@samp.rate)
playsound(as.vector(fcast$fitted), path='/usr/bin/vlc', fs=watain@samp.rate)

as.vector(diff.black) == as.vector(fcast$fitted)

ndiffs(watain@left, alpha=0.05, test=c("kpss")) 
ndiffs(satyricon@left, alpha=0.05, test=c("kpss"))
dchick <- diff(watain@left)
degg <- diff(satyricon@left)
par(mfrow=c(2,1))
plot.ts(dchick)library(pacman)
p_load(tuneR, pastecs, seewave, soundecology, neuralnet)
library(arules)
library(arulesSequences)
library(Matrix)

get.matrix <- function(f, dir='wavs/black/', t='black'){
  
  sndObj <- readWave(paste(dir,'/',f,sep=''))
  
  file.name <- gsub('.wav','', f)
  
  s1 <- sndObj@left
  s1 <- s1 / 2^(sndObj@bit -1)
  
  s2 <- sndObj@right
  s2 <- s2 / 2^(sndObj@bit -1)
  
  n <- length(s1)
  timeArray <- (0:(n-1)) / sndObj@samp.rate
  timeArray <- timeArray  * 1000 #scale to milliseconds
  #plot(timeArray, s1[1:length(timeArray)], type='l', col='black', xlab='Time (ms)', ylab='Amplitude')
  
  p <- fft(s1)
  
  # nUniquePts <- ceiling((n+1)/2)
  # p <- p[1:nUniquePts] #select just the first half since the second half
  # is a mirror image of the first
  p <- abs(p)  #take the absolute value, or the magnitude
  
  p <- p / n #scale by the number of points so that
  # the magnitude does not depend on the length
  # of the signal or on its sampling frequency
  p <- p^2  # square it to get the power
  
  # multiply by two (see technical document for details)
  # odd nfft excludes Nyquist point
  if (n %% 2 > 0){
    p[2:length(p)] <- p[2:length(p)]*2 # we've got odd number of points fft
  } else {
    p[2: (length(p) -1)] <- p[2: (length(p) -1)]*2 # we've got even number of points fft
  }
  
  freqArray <- (0:(length(s1))) * (sndObj@samp.rate / n) #  create the frequency array
  
  #plot(freqArray/1000, 10*log10(p), type='l', col='black', xlab='Frequency (kHz)', ylab='Power (dB)')
  
  #metal.df <- data.frame(s1[2:length(timeArray)], 10*log10(p)[2:length(timeArray)])
  metal.df <- data.frame(s1)
  #names(metal.df) <- c('amp', 'freq')
  
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



sndObj <- readWave('wavs/black/burzum.det.som.wav')


Wobjm <- mono(sndObj, "left") # extract the left channel
# and downsample to 11025 samples/sec.:
Wobjm11 <- downsample(Wobjm, 11025)
# extract a part of the signal interactively (click for left/right limits):

## Not run:
#Wobjm11s <- extractWave(Wobjm11)
## End(Not run)

# or extract some values reproducibly
Wobjm11s <- extractWave(Wobjm11, from=0, to=100000)

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
snotes <- na.omit(snotes)
notenames(snotes, language = 'english')
# plot melody and energy of the sound:
m <- melodyplot(WspecObject, snotes)
m$notenames

# apply some quantization (into 8 parts):
qnotes <- quantize(snotes, WspecObject@energy, parts = 8)
# an plot it, 4 parts a bar (including expected values):
quantplot(qnotes, expected = rep(c(0, -12), each = 4), bars = 2)
# now prepare for LilyPond
qlily <- quantMerge(snotes, 4, 4, 2)
qlily


oscillo(sndObj, f=22050, k=2, j=2, byrow=T)

op<-par(bg="grey")
oscillo(sndObj,f=22050,k=4,j=1,title=TRUE,colwave="black",
        coltitle="yellow",collab="red",colline="white",
        colaxis="blue",coly0="grey50")

oscillo(sndObj,f=22050)
par(new=TRUE)
env(sndObj,f=22050,colwave=2)

ifreq(sndObj,f=22050,threshold=5)

op<-par(mfrow=c(2,1))
spec(sndObj,f=22050,type="l")
meanspec(sndObj,f=22050,wl=512,type="l")

op <- par(op)
spectro(sndObj,f=22050,wl=512,ovlp=50,zp=16,collevels=seq(-80,0,0.5))

op <- par(op)
pellu2<-cutw(sndObj,f=22050,from=1,plot=FALSE)
spectro(pellu2,f=22050,wl=512,ovlp=85,collevels=seq(-100,0,1),osc=TRUE,
        palette=reverse.heat.colors,colgrid="white", colwave="white",colaxis="white",
        collab="white", colbg="black")
par(op)

spectro3D(sndObj,f=22050,wl=512,ovlp=75,zp=16,maga=2)
par(op)

par(new=T)
timer(sndObj,f=22050,threshold=5, ssmoth=900, bty="l",colval="blue")



spectro(sndObj, f=22050, ovlp=50, palette=reverse.gray.colors.2, scale=FALSE)
par(new=T)
dfreq(sndObj.death, f=22050, ovlp=50, threshold=6, col="red", ann=FALSE, xaxs="i", yaxs="i")
m<-dfreq(sndObj, f=22050, ovlp=50, threshold=6, col="red", ann=FALSE, xaxs="i", yaxs="i", plot=F)
m.death<-dfreq(sndObj.death, f=22050, ovlp=50, threshold=6, col="red", ann=FALSE, xaxs="i", yaxs="i", plot=F)

write.table(m[,1], 'freq.tsv', row.names = F, sep = '\t')
x <- read_baskets(con=system.file('.', "freq.tsv", package = "arulesSequences"), 
                  info = c("item"))
x

data(Adult)
inspect(head(Adult, 1))
Adult_abbr <- abbreviate(Adult, 15)
inspect(head(Adult_abbr, 1))


f <-sndObj@samp.rate
ticon <- sndObj@left/max(sndObj@left) + noisew(d = length(sndObj@left)/f, f)
res <- dfreq(ticon, f, clip = 0.3, plot = FALSE)
spectro(ticon, f, palette = reverse.gray.colors.2)
points(res, col = "red", bg = "yellow", pch = 21)
par(op)

par(new=T)
res <- autoc(sndObj, threshold=10, fmin=100, fmax=700, plot=FALSE)
spectro(sndObj, ovlp=75, scale=FALSE)
points(res, pch=20)
legend(0.5,3.6, "Frecuencia fundamental", pch=20, col="black", bty=0, cex=0.7)
par(op)

spec1 <- spec(sndObj, f=22050, at=0.2, plot=FALSE)
spec2 <- spec(sndObj, f=22050, at=1.2, plot=FALSE)
corspec(spec1, spec2, main="correlacion cruzada de espectros")

m <- spec(wave=sndObj, wn ="hanning", f=sampfreq, norm=F, wl=512, plot=F, identify=T)
m.death <- spec(wave=sndObj.death, wn ="hanning", f=sampfreq, norm=F, wl=512, plot=F, identify=T)

par(mfrow = c(2,1))
x.black <- sapply(1:1000,function(x) mean(sample(m[,2],size=500)))
x.death <- sapply(1:1000,function(x) mean(sample(m.death[,2],size=500)))

hist(x.black, breaks = 50)
hist(x.death, breaks = 50)


acoustic_complexity(sndObj, max_freq = 8000)$AciTotAll_left
acoustic_complexity(sndObj, max_freq = 8000)$AciTotAll_right
acoustic_diversity(sndObj)
acoustic_complexity(sndObj)




#library(neuralnet)
set.seed(500)
library(MASS)
data <- Boston

apply(data,2,function(x) sum(is.na(x)))

index <- sample(1:nrow(data),round(0.75*nrow(data)))
train <- data[index,]
test <- data[-index,]
lm.fit <- glm(medv~., data=train)
summary(lm.fit)
pr.lm <- predict(lm.fit,test)
MSE.lm <- sum((pr.lm - test$medv)^2)/nrow(test)

maxs <- apply(data, 2, max)
mins <- apply(data, 2, min)

scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))

train_ <- scaled[index,]
test_ <- scaled[-index,]


n <- names(train_)
f <- as.formula(paste("medv ~", paste(n[!n %in% "medv"], collapse = " + ")))
nn <- neuralnet(f,data=train_,hidden=c(5,3),linear.output=F)

plot(nn)

pr.nn <- compute(nn,test_[,1:13])

pr.nn_ <- pr.nn$net.result*(max(data$medv)-min(data$medv))+min(data$medv)
test.r <- (test_$medv)*(max(data$medv)-min(data$medv))+min(data$medv)

MSE.nn <- sum((test.r - pr.nn_)^2)/nrow(test_)

print(paste(MSE.lm,MSE.nn))

par(mfrow=c(1,2))

plot(test$medv,pr.nn_,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN',pch=18,col='red', bty='n')

plot(test$medv,pr.lm,col='blue',main='Real vs predicted lm',pch=18, cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='LM',pch=18,col='blue', bty='n', cex=.95)

par(mfrow=c(1,1))
plot(test$medv,pr.nn_,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
points(test$medv,pr.lm,col='blue',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend=c('NN','LM'),pch=18,col=c('red','blue'))





plot.ts(degg)
par(mfrow=c(1,1))
len <- min(length(dchick), length(degg))
grangertest(degg[1:len] ~ dchick[1:len], order=4)

par(mfrow=c(3,1))
plot(fcast$fitted, ylab="frequency")
plot(ts(watain@left, frequency = watain@samp.rate, start=1), ylab="forkwency")
plot(ts(satyricon@left, frequency = satyricon@samp.rate, start=1), ylab="forkwency")
par(mfrow=c(1,1))

oscillo(fcast$fitted)

w=rep(NA,12)
for(w in 1:12){
  w[m]=SPE_Backcast[m]/(SPE_Backcast[m]+SPE_Forecast[m]);
}

ts(df[complete.cases(df),]$watain, frequency=1000, start=1) - ts(df[complete.cases(df),]$satyricon, frequency=1000, start=1)
watain@left[1:4]
satyricon@left[1:4]
#-652   284   859  1088
x <- as.vector(fcast$fitted)
#x[1:190000] <- rep(0, 190000)
playsound(s1, path='/usr/bin/vlc', fs=80000)
playsound(s2, path='/usr/bin/vlc', fs=80000)
playsound(s3, path='/usr/bin/vlc', fs=80000)
playsound(as.vector(fcast$fitted), path='/usr/bin/vlc', fs=80000)
p <- fft(amplitute)


x <- seq(0, 2*pi, length = 44100)
channel <- round(32000 * sin(440 * x))
Wobj <- Wave(left = channel)
playsound(Wobj@left, path='/usr/bin/vlc', fs=80000) 

str(Wobj)

nUniquePts <- ceiling((n+1)/2)
p <- p[1:nUniquePts] #select just the first half since the second half
# is a mirror image of the first
p <- abs(p)  #take the absolute value, or the magnitude

p <- p / n #scale by the number of points so that
# the magnitude does not depend on the length
# of the signal or on its sampling frequency
p <- p^2  # square it to get the power

# multiply by two (see technical document for details)
# odd nfft excludes Nyquist point
if (n %% 2 > 0){
  p[2:length(p)] <- p[2:length(p)]*2 # we've got odd number of points fft
} else {
  p[2: (length(p) -1)] <- p[2: (length(p) -1)]*2 # we've got even number of points fft
}

freqArray <- (0:(length(amplitute))) * (watain@samp.rate / n) #  create the frequency array

plot(freqArray/1000, 10*log10(p), type='l', col='black', xlab='Frequency (kHz)', ylab='Power (dB)')

