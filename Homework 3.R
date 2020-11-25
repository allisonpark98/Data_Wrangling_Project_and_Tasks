#QBS 181 Homework 3
#1a
spread(table2,key=type,value=count) %>%
  select(country, year, cases)

#1b
q1_b <- spread(table2,key=type,value=count) %>%
  select(country, year, population) 
  
#1c
table2_1c <- spread(table2, key=type,value=count) %>%
  mutate(rate = cases/population * 10000); table2_1c
#table4a + table4b
rate_1999 <- tibble(country = table4a$country,
                    year = 1999,
                    rate = table4a$`1999` / table4b$`1999` * 10000)
rate_2000 <- tibble(country = table4a$country,
                    year = 2000,
                    rate = table4a$`2000` / table4b$`2000` * 10000)
q_1c <- rbind(rate_1999, rate_2000) %>% arrange(country); q_1c


#1d
table2_1c %>% select(-c(cases, population))

#3a
library(nycflights13)
data("flights")
flights %>%
  filter(!is.na(dep_time)) %>%
  group_by(hour) %>%
  mutate(month = factor(month)) %>%
  ggplot(.,aes(x= hour, color = month)) +
  geom_freqpoly(binwidth = 1) +
  labs(x = "Hour of Day", y= "Number of Flights", subtitle = "Distribution of Flights in a Day per Month in 2013")


flights %>%
  mutate(#time = hour(dep_time) * 100 + minute(dep_time),
         mon = as.factor(month)) %>%
  ggplot(aes(x = hour, y = ..density.., group = mon, color = mon)) +
  geom_freqpoly(binwidth = 100)

#3b
flights$calculated_delay <- flights$sched_dep_time - flights$dep_time
q3_c <- flights %>%
  select(dep_time, sched_dep_time, dep_delay)

#3c
flights$binary_delay <- ifelse(flights$dep_delay < 0,"1","0")
flights %>%
  group_by(minute)
flights2 <- flights %>%
  group_by(gr=cut(minute, breaks= seq(0, 60, by = 10))) %>%
  count(binary_delay) %>%
  drop_na()
flights2 %>%
  ggplot(.,aes(x= gr, y=n, fill = binary_delay)) + 
  geom_bar(stat="identity", position = position_dodge()) +
  labs(x= "10 Minute Groupings", y = "Count", fill = "Delay (1: No Delay)") +
  theme_minimal()

#4
library(Rfacebook)
app_id <- "1586985184796102"
app_secret <- "ae677350ed4337ec18fde427b0cbbab2"
token <- 'EAALirT3sv7MBAADDpHCxEkiRWgeZBV8jUUsNXEvrrj7Q4KuGpPIysqaxbd8IuzzQaqSVzghz7oa5F9WghoiSQXiKf24w4yYdZCdZA7qijkjiZBCTO3EAmCZCu0ZBGwyxXDqNYW24PuP290UoK0CGlx4iKULycuDVpMQqYUGBatvtEYlFupquVIH5iB1PlqfcZB5d7ftyp0weO46XZClkFwM904oYyZCqEF52uauefJO4KPQZDZD'
fbOAuth(app_id, app_secret)
results <- searchFacebook("page", token, n =10)
