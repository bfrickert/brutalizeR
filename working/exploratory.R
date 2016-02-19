library(pacman)
p_load(tuneR, pastecs, seewave, soundecology, neuralnet)
library(arules)
library(arulesSequences)
library(Matrix)



sndObj <- readWave('wavs/black/burzum.det.som.wav')
t <- ts(sndObj@left, frequency = 44100)
plot.ts(t, ylab='', main="10 seconds of Burzum's 'Det Som Engang Var'")
vac <- readWave('wavs/vacation/vacation.wav')
t.vac <- ts(vac@left, frequency = 44100)
plot.ts(t.vac, ylab='', main="10 seconds of The Go-Go's 'Vacation'")

vac <- readWave('wavs/vacation/vacation.wav')

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

oscillo(sndObj,f=44101)
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




