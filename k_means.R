library(tidyverse)
library(nycflights13)
library(ggplot2)
library(DBI)


# raw data
dat <- readr::read_rds("student_personas_lession.rds")

dat_1 <- dat %>% 
  select(-student_id,-mobile) #去掉studentid以及mobile

dat_1

table(is.na(dat$total_catogery))# 判断空值列

for (i=1 in 29)

