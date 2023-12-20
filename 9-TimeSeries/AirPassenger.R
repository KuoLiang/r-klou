#Monthly Deaths from Lung Diseases in the UK
#both sexes (ldeaths), males (mdeaths) and females (fdeaths).

yr <- floor(tt <- time(mdeaths)) #sampling times
yr
tt
plot(mdeaths, fdeaths)
###
m_fit <- auto.arima(mdeaths)
forecast(m_fit, 5)
plot(forecast(m_fit, 5), xlab ="Monthely Data",
     ylab ="Cases",
     main ="Male", col.main ="darkgreen")


###
f_fit <- auto.arima(fdeaths)
forecast(f_fit, 5)
plot(forecast(f_fit, 5), xlab ="Monthely Data",
     ylab ="Cases",
     main ="Female", col.main ="darkgreen")
###
data(AirPassengers)
class(AirPassengers)
AirPassengers
plot(AirPassengers)
reg=lm(AirPassengers~time(AirPassengers))
abline(reg)
summary(reg)

a_fit <- auto.arima(AirPassengers)
plot(forecast(a_fit, 5), xlab ="Monthely Data",
     ylab ="Monthly",
     main ="AirPassengers", col.main ="darkgreen")

