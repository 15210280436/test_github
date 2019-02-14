library(tidyverse)
library(nycflights13)

library(DBI)
con <- DBI::dbConnect(RPostgreSQL::PostgreSQL(),
                      host   = "127.0.0.1",
                      dbname = "octopus_susuan",
                      user      = "wangjf",
                      password      = "d4aSXN2P",
                      port     = 5000)

student <- tbl(con,"o_student")

dbDisconnect(con)

mpg
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy), color = "blue")

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy),color = "orange") +
  facet_wrap(~ class,nrow = 3)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy),color = "orange") +
  facet_grid(drv ~ cyl)

mpg %>% 
  distinct(cyl)

flights %>% 
  filter(month==1 & day==1,is.na(dep_time)) #is.na()选择有缺失值的

flights %>%
  arrange(desc(is.na(dep_time)))

df <- tibble(x = c(5, 2, NA)) 
arrange(df, x)

flights %>% 
  rename(year_1=year) 

flights %>% 
  mutate(strptime(dep_time,'%H:%M:%S %Y')) #表示两个字段之间所有列
  
flights %>% 
  transmute(dep_time,hour=dep_time %/% 60,minit=dep_time %%60) #转变时间

flights %>% 
  select(-(year:dep_delay)) #表示不在两个字段之间所有列

flights_sml <- flights %>% 
  select(year:day,ends_with("delay"),distance,air_time) #ends_with结尾包含delay的lie
flights_sml %>% 
  mutate(gain=air_time-dep_delay,
         speed=distance/air_time*60)
flights_sml %>% 
  transmute(gain=air_time-dep_delay, #transmute只保留增加的变量
         speed=distance/air_time*60)

flights %>% 
  select(origin,tailnum,dep_time) %>% 
  group_by(origin,tailnum) %>% 
  arrange(desc(dep_time)) 

flights %>% 
  group_by(year,month,day) %>% 
  summarise(delay=mean(dep_delay,na.rm = TRUE)) #na.rm 去掉空值

diamonds1 <- diamonds %>% 
  mutate(y_1=ifelse(y<3 | y>20,NA,y))

diamonds1 %>% 
  ggplot(mapping = aes(x=x,y=y_1))+
  geom_point()

flights %>% 
  mutate(
    cancelled=is.na(dep_time),# is.na =true表示dep_time为空的取消航班标签。
    sched_hour=sched_dep_time %/% 100,
    sched_min=sched_dep_time %% 100,
    sched_dep_time=sched_hour+sched_min/60
  ) %>% 
  ggplot(mapping = aes(x=sched_dep_time,y=..density..,color=cancelled))+
  geom_freqpoly(binwidth=500)


