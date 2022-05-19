# Metro Interstate Traffic Analysis
 Analysis of metro interstate traffic volume using the methods of time series and spectral analysis.


## Intention
The core intent of this project was to use various time series analysis techniques to model and forecast the traffic volume on metro interstate-94.


## Data
[RawData](https://archive.ics.uci.edu/ml/datasets/Metro+Interstate+Traffic+Volume): Metro_Interstate_Traffic_Volume.csv

Interim (saved post DataPrep): final_data.csv


## Methods
We used Seasonal ARIMA models and linear regression to carry out univariate and multivariate time series analysis respectively. Furthermore, to check on these, spectral analysis was done to identify the periods in data (which relates to the SARIMA model). Basic neural network representation was used to simply fit the data and forecast.


## Future Work and Improvements
More sophisticated methods could be looked into handling the missing dates and data. Additionally, the scope of this project was modeling just one particular hour of the day and that's why the code would not be able to scale to all hours directly. Either new algorithms coule be used or a very dynamic code could be built to model all hours of the day simultaneously.
