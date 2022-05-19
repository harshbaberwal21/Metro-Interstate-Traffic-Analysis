
repo_path ='/Users/harshbaberwal/Documents/Github/Metro-Interstate-Traffic-Analysis/'
setwd(repo_path)

final_data <- read.csv('Data Folder/final_data.csv')


#Checking for any high correlations
heatmap(cor(final_data[, 2:16], use = "na.or.complete"))

#Plotting the traffic volume against time
tsplot(final_data$t, final_data$traffic_volume, ylab = "Traffic Volume", xlab = "Date", gg = T)

#Checking the stationarity of the series
adf.test(final_data$traffic_volume)

#Basic Numerical Summary
summary(final_data$traffic_volume)


# Running a step-wise linear regression model to get the best model
step(lm(traffic_volume ~ holiday + temp + rain_1h + clouds_all + 
          weather_main_Clear + weather_main_Clouds +
          weather_main_Drizzle + weather_main_Fog + weather_main_Haze +
          weather_main_Mist + weather_main_Rain + 
          weather_main_Smoke + weather_main_Snow + 
          weather_main_Thunderstorm + date, final_data), direction = "backward")

# Chosen Model
modelA <- lm(traffic_volume ~ holiday + temp + rain_1h + weather_main_Drizzle +
               weather_main_Fog + weather_main_Mist + weather_main_Rain + 
               weather_main_Snow + date, final_data)

# Model Summary
summary(modelA)

# AIC and BIC of the model
print(paste("AIC: ",AIC(modelA)))
print(paste("BIC: ",BIC(modelA)))



# Residual Analysis
x <- resid(modelA)

#Checking the residuals stationarity
adf.test(x)

#Plotting residuals
tsplot(x, ylab = "Residual",  gg = T)
acf2(x, main = "Residual", gg = T)

# Since ACF shows seasonal persistence so, we try differencing
tsplot(diff(x, 7), ylab = "Seasonal Differenced Residual", gg = T)
acf2(diff(x, 7), main = "Seasonal Differenced Residual", gg = T)


#ACF cuts off, PACF tails off, for seasonal 
#So MA(1) models are chosen for seasonal.
#PACF cuts off, ACF tails off, for non seasonal 
#So AR(1) models are chosen for non seasonal.
#ARIMA(1,0,0)X(0,1,1)_s=7

sarima(x, p=1,d=0,q=0,P=0,D=1,Q=1,S=7)

# Iterating several others to to check
sarima(x, 0,0,1,0,1,1,7)
sarima(x, 1,0,1,0,1,1,7)
sarima(x, 1,0,2,0,1,1,7)
sarima(x, 2,0,1,0,1,1,7)
sarima(x, 2,0,2,0,1,1,7)

# Best model for residuals:
sarima(x, 1,0,2,0,1,1,7)


# Final Model
sarima(final_data$traffic_volume, 1,0,2,0,1,1,7, xreg = final_data[, c(1,2,3,4,9,10,12,13,15)], gg = T)
