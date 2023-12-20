my_ts <- ts(1:100, start=2000) #由2000年開始100個資料
my_ts
your_ts <- ts(1:100, start=c(2000,10),frequency=12)#每月
your_ts
his_ts <- ts(1:100, start=c(2000,10),frequency=4)# 每季
his_ts
her_ts <- ts(1:100, start=decimal_date(ymd("2000-01-01")),
             frequency=7)#七天一數值，最後第100個為 2014第二週
her_ts
#Weekly data of COVID-19 positive cases from
# 22 January, 2020 to 15 April, 2020
pCases <- c(580, 7813, 28266, 59287,
            75700, 87820, 95314, 126214,
            218843, 471497, 936851,
            1508725, 2072113)

# creating time series object
# from date 22 January, 2020
first_ts <- ts(pCases, start = decimal_date(ymd("2020-01-22")),
          frequency = 365.25 / 7)

# plotting the graph
plot(first_ts, xlab ="Weekly Data",
     ylab ="Total Positive Cases",
     main ="COVID-19 Pandemic",
     col.main ="darkgreen")

############

dCases <- c(17, 270, 565, 1261, 2126, 2800,
            3285, 4628, 8951, 21283, 47210,
            88480, 138475)

# creating multivariate time series object
# from date 22 January, 2020
second_ts <- ts(cbind(pCases, dCases),
          start = decimal_date(ymd("2020-01-22")),
          frequency = 365.25 / 7)

# plotting the graph
plot(second_ts, xlab ="Weekly Data",
     main ="COVID-19 Cases",
     col.main ="darkgreen")


###########
install.packages("forecast")
library(forecast)

third_ts <- ts(pCases, start = decimal_date(ymd("2020-01-22")),
          frequency = 365.25 / 7)

fit <- auto.arima(third_ts)
# Next 5 forecasted values
forecast(fit, 5)

# plotting the graph with next
# 5 weekly forecasted values
plot(forecast(fit, 5), xlab ="Weekly Data",
     ylab ="Total Positive Cases",
     main ="COVID-19 Pandemic", col.main ="darkgreen")
