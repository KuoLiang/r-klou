yr <- floor(tt <- time(mdeaths)) #sampling times
tt
plot(mdeaths, fdeaths,
     xy.labels = paste(month.abb[12*(tt - yr)], yr-1900, sep = "'"))

###
data(AirPassengers)
class(AirPassengers)
AirPassengers
plot(AirPassengers)
abline(reg=lm(AirPassengers~time(AirPassengers)))
summary(reg)
cycle(AirPassengers) ### sampling times
plot(aggregate(AirPassengers,FUN=mean))
boxplot(AirPassengers~cycle(AirPassengers))
