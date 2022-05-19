


repo_path ='/Users/harshbaberwal/Documents/Github/Metro-Interstate-Traffic-Analysis/'
setwd(repo_path)

final_data <- read.csv('Data Folder/final_data.csv')

# Calculating the spectral densities
sp <- spec.pgram(final_data$traffic_volume,taper=0,log="no")


# Sorting the densities
sort_specs <- sort(sp$spec, decreasing = TRUE)[c(1,2,3)]

# Using frequencies with highest spectral density (the 3 peaks) and calculating the period using these.
p1 <- sp$freq[sp$spec==sort_specs[1]]
p1
1/p1

p2 <- sp$freq[sp$spec==sort_specs[2]]
p2
1/p2

p3 <- sp$freq[sp$spec==sort_specs[3]]
p3
1/p3


# Since p2 and p3 are very close, we try smoothing and then build the periodogram again
tyt.per <- mvspec(final_data$traffic_volume, kernel('daniell', 2), log="no", main = "Smoothed Periodogram")

# The frequencies below are chosen for sudden spectrum density peaks by eyeballing tyt.per
abline(v=tyt.per$freq[3], lty=2)
abline(v=tyt.per$freq[174], lty=2)

# Periods
1/tyt.per$freq[3]
1/tyt.per$freq[174]



## Quick Forecast using Neural Network
fit <- nnetar(final_data$traffic_volume, lambda=0)
nn.for <- forecast(fit,h=30)
autoplot(nn.for)
