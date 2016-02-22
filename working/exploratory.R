library(pacman)
p_load(tuneR, seewave, ggplot2, plyr, grid)

par(mfrow=c(1,1))
sndObj <- readWave('wavs/black/burzum.det.som.wav')
t <- ts(sndObj@left, frequency = 44100)
plot.ts(t, ylab='', main="10 seconds of Burzum's 'Det Som Engang Var'")
vac <- readWave('wavs/vacation/vacation.wav')
t.vac <- ts(vac@left, frequency = 44100)
plot.ts(t.vac, ylab='', main="10 seconds of The Go-Go's 'Vacation'")

par(mfrow=c(1,2))
inno <- readWave('wavs/black/emperor.inno.wav')
oscillo(inno,f=44101, title="Amplitude of Emperor's\n'Inno Satanis'")

solar <- readWave('wavs/black/immortal.solarfall.wav')
ifreq(solar,f=44100,main='Frequency of Immortal\'s\n\'Solarfall\'')

par(mfrow=c(1,1))
sndObj <- readWave('wavs/gogos/lips.are.sealed.wav')
Wobjm <- mono(sndObj, "left")
Wobjm11 <- downsample(Wobjm, 44100)
Wobjm11s <- extractWave(Wobjm11, from=0, to=4000000)
WspecObject <- periodogram(Wobjm11s, normalize = TRUE, width = 1024, overlap = 512)
ff <- FF(WspecObject)
notes <- noteFromFF(ff, 440)
snotes <- smoother(notes)
melodyplot(WspecObject, snotes, main="Melody Plot of The Go-Go's\n'Our Lips Are Sealed'")


df <- data.frame(c(rep('black metal', 100000), rep('go-go\'s', 100000)),
c(black.samples, gogo.samples))
names(df) <- c('type', 'var')
var.dat <- ddply(df, "type", summarise, var.mean=mean(var))

black.dens <- density(black.samples)
gogo.dens <- density(gogo.samples)
black.dens.df <- data.frame(type='Black Metal', x=black.dens$x,y=black.dens$y)
gogo.dens.df <- data.frame(type='Go-Go\'s', x=gogo.dens$x,y=gogo.dens$y)
dens.df <- cbind(black.dens.df, gogo.dens.df)

vac.list <- var.each.sec('vacation.wav', 'wavs/gogos')
vac.samples <- replicate(100000, mean(sample(unlist(vac.list),100,replace = F)))
change.dat <- data.frame(mean=mean(vac.samples))

#################
black.metal <- readWave('wavs/black/watain.malfeitor.wav')

vacation <- readWave('wavs/vacation/vacation.wav')

minimum <- min(length(black.metal@left), length(vacation@left))

s1 <- black.metal@left[1:minimum]
s2 <- vacation@left[1:minimum]

all <- merge(black.metal=as.zoo(ts(s1,start=1)), vacation=as.zoo(ts(s2,start=1)))

df.diff<- data.frame(all)

diff.black <- ts(with(df.diff[complete.cases(df.diff),], vacation + (as.numeric(0.728879)*black.metal)), frequency=vacation@samp.rate, start=1)

savewav(diff.black, f=44100, filename='wavs/newfiles/new.wav')
black.metal.list <- var.each.sec('new.wav', dir='wavs/newfiles')
black.metal.samples <- replicate(100000, mean(sample(unlist(black.metal.list),100,replace = F)))
print(mean(black.metal.samples))
full.change.dat <- data.frame(mean=39944239)
#0.728879
###################

ggplot(df, aes(x=var, fill=type)) + scale_fill_manual(values=c("black", "purple")) + 
  geom_density(alpha=.3) +
#   geom_area(data = subset(black.dens.df, x >= quantile(black.samples, .05) & 
#                             x <= quantile(black.samples, .95)),  
#             aes(x=x,y=y), fill = 'black') +
#   geom_area(data = subset(gogo.dens.df, x >= quantile(gogo.samples, .05) & 
#                             x <= quantile(gogo.samples, .95)),  
#             aes(x=x,y=y), fill = 'purple') +
  geom_vline(data=var.dat, aes(xintercept=var.mean,  colour=type),
             linetype="dashed", size=1) + scale_color_manual(values=c("red", "green"))  + 
  geom_vline(data=change.dat, aes(xintercept=mean),
             linetype="dashed", size=1)  + 
  geom_text(mapping=aes(x=mean(vac.samples), y=1.5e-07, label='Vacation'), size=6, 
            angle=90, vjust=-0.4, hjust=0) +
  theme_bw()  +
theme(axis.line = element_line(colour = "black"),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank()) +
  labs(x="Variance", y="Density", title="Density Plot of Mean Variances of 
       Representative Black
       Metal and Go-Go's Songs")

#########################################################################################
