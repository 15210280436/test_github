library(tidyverse)
library(nycflights13)
library(ggplot2)
library(DBI)
con <- DBI::dbConnect(RPostgreSQL::PostgreSQL(),
                      host   = "127.0.0.1",
                      dbname = "octopus_susuan",
                      user      = "wangjf",
                      password      = "d4aSXN2P",
                      port     = 5000)

student <- tbl(con,"o_student")

student_1 <- head(student,n=100) %>% 
  collect()

student_1

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

student_1 %>% 
  filter(grade<8) %>% 
  ggplot(mapping=aes(x=grade,color=grade))+
  geom_bar()

# geom_point and geom_smooth 配合使用，可以看到散点以及趋势

student_1 %>% 
  filter(grade<8) %>% 
  ggplot(mapping=aes(x=grade,y=province_id))+
  geom_boxplot()

seq(1,10)

by_dest <- flights %>% 
  group_by(dest)
delay <- by_dest %>% 
  summarise(count=n(),dist=mean(distance,na.rm=TRUE),delay=mean(arr_delay,na.rm=TRUE))
delay <- filter(delay,count>20,dest!="HNL")

delay %>% 
  filter(dist<750) %>% 
  ggplot(mapping = aes(x=dist,y=delay))+
  geom_point(aes(size=count),alpha=1/3)+
  geom_smooth(se=FALSE)

flights %>% 
  group_by(tailnum) %>% 
  summarise(delay=mean(arr_delay,na.rm=TRUE),n=n()) %>% 
  ggplot(mapping=aes(x=n,y=delay))+
  geom_point(alpha=1/10)

diamonds %>% 
  filter(carat<3) %>% 
  ggplot(mapping = aes(x=carat,color=cut))+
  geom_freqpoly(binwidth=0.1)

diamonds %>% #直方图+密度图
  filter(carat<3) %>% 
  ggplot(mapping = aes(x=carat,y=..density..))+
  geom_histogram(binwidth=0.1)+
  geom_density(alpha=.7)

  