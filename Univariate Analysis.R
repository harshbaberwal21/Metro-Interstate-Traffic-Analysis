
repo_path ='/Users/harshbaberwal/Documents/Github/Metro-Interstate-Traffic-Analysis/'
setwd(repo_path)

final_data <- read.csv('Data Folder/final_data.csv')


# Univariate time series analysis

#Plotting the data
tsplot(final_data$traffic_volume, ylab = "Traffic Volume", xlab = "Date", gg = T)

#Stationarity Check
adf.test(final_data$traffic_volume)


# Checking ACF and PACF
acf2(final_data$traffic_volume,  main = "Traffic Volume", gg = T)

#Seasonal Persistence is present, so we try differencing
y <- diff(final_data$traffic_volume, 7)

# Plotting the series
tsplot(y, ylab = "Seasonal Differenced Traffic Volume", xlab = "Date", gg = T)

# Checking the ACF again
acf2(y, main = "Seasonal Differenced Traffic Volume", gg = T)

# ACF cuts off, PACF tails off, for seasonal 
# So MA(1) models are chosen for seasonal.
# ACF and PACF both cut off after lag 1.
# We cannot be sure of the ARMA order for the non-seasonal part
# we begin with AR(1) and MA(1) for non-seasonal and then run iteratively to identify the best model
#ARIMA(1,0,0)X(0,1,1)_s=7

#Trying various models iteratively
sarima(final_data$traffic_volume, 1,0,1,0,1,1,7)
sarima(final_data$traffic_volume, 2,0,1,0,1,1,7)
sarima(final_data$traffic_volume, 1,0,2,0,1,1,7)
sarima(final_data$traffic_volume, 2,0,2,0,1,1,7)



# Final Model
sarima(final_data$traffic_volume, 2,0,1,0,1,1,7)


# Forecasting traffic volume for a week ahead
sarima.for(final_data$traffic_volume, 7,2,0,1,0,1,1,7)
