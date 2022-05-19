
repo_path ='/Users/harshbaberwal/Documents/Github/Metro-Interstate-Traffic-Analysis/'
setwd(repo_path)

# Importing the data
df <- read.csv('Data Folder/Metro_Interstate_Traffic_Volume.csv')

# Parsing the date-time as per available format
df$date_time_c = strptime(df$date_time, format = "%Y-%m-%d %H:%M:%S")

# Separating indivudual elements of date-time (or date-hour)
df = df %>% mutate(dt_year = as.integer(format(date_time_c, "%Y")),
                   dt_month = as.integer(format(date_time_c, "%m")),
                   dt_day = as.integer(format(date_time_c, "%d")),
                   dt_hour = as.integer(format(date_time_c, "%H")))

# Creating final date variable
df <- df %>% mutate(date = make_date(dt_year, dt_month, dt_day))

# Mapping the holiday flag to all the hours of a date
ff <- df %>%  mutate(h = if_else(holiday == 'None', 0, 1))%>%
  filter(h == 1)%>% select(c("date", "h"))

df <- df  %>% left_join(ff, by = "date") %>% 
  mutate(holiday = if_else(is.na(h), 0, 1)) %>% select(-c("h", "date"))



# Filtering for hour = 20 i.e. 8.00 PM and for year > 2014
df <- df %>%  filter(dt_hour == 20) %>% select(-c("dt_hour")) %>% 
  filter(dt_year > 2014) %>% filter(traffic_volume > 1000)

# One-hot Encoding the weather description variable
df = df %>% select(-c("weather_description", "date_time", "date_time_c"))
df$weather_main <- as.factor(df$weather_main)
df = one_hot(as.data.table(df))


# Setting up the final data
final_data <- df %>% 
  mutate(date = make_date(dt_year, dt_month, dt_day)) %>% 
  select(-c("dt_year", "dt_month", "dt_day"))

final_data = final_data %>% 
  group_by(date) %>% 
  summarize(
    holiday=mean(holiday),
    temp=mean(temp),
    snow_1h=mean(snow_1h),
    rain_1h=mean(rain_1h),
    clouds_all=mean(clouds_all),
    traffic_volume=mean(traffic_volume),
    weather_main_Clear=sum(weather_main_Clear),
    weather_main_Clouds=sum(weather_main_Clouds),
    weather_main_Drizzle=sum(weather_main_Drizzle),
    weather_main_Fog=sum(weather_main_Fog),
    weather_main_Haze=sum(weather_main_Haze),
    weather_main_Mist=sum(weather_main_Mist),
    weather_main_Rain=sum(weather_main_Rain),
    weather_main_Smoke=sum(weather_main_Smoke),
    weather_main_Snow=sum(weather_main_Snow),
    weather_main_Thunderstorm=sum(weather_main_Thunderstorm)
  )

final_data <- final_data %>% select(-c("snow_1h"))
final_data$t <- year(final_data$date) + yday(final_data$date)/365
t <- final_data$date
# final_data$date <- final_data$t - mean(final_data$t)


# Imputing missing dates
date_col <- seq.Date(as.Date(t[1]), as.Date(t[length(t)]), by = "day")
df <- data.frame(matrix(NA, ncol = 17))
colnames(df) <- colnames(final_data)
for (d in date_col){
  temp <- final_data %>% filter(date == d)
  if(nrow(temp) > 0){
    df <- rbind(df, temp)
  }else{
    temp <- c(d, rep(NA, 16))
    df <- rbind(df, temp)
  }
}

df <- df[2:nrow(df), ]
df[, "date"] <- date_col
final_data <- df


# Encoding the daye of year using year value and day fraction
final_data$t <- year(final_data$date) + yday(final_data$date)/365
t <- final_data$date

# Mean centering the date variable created
final_data$date <- final_data$t - mean(final_data$t)

# Imputing NAs
final_data <- na_kalman(final_data)


# Writing the final data
write.csv(final_data, 'Data Folder/final_data.csv', row.names = FALSE)
