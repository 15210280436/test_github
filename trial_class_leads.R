library(tidyverse)
library(ggthemes)
library(ggplot2)


# read data
trail_class_leads <- readxl::read_xls("trial_class.xls")

trail_class_leads <- 
  trail_class_leads %>% 
  rename(source_1=source)

temp_1 <- trail_class_leads %>% 
  filter(status==1) %>% 
  group_by(date,source_1) %>% 
  summarise(n=n()) %>% 
  ungroup() %>% 
  spread(source_1,n)

temp_0 <- trail_class_leads %>% 
  filter(status==0) %>% 
  group_by(date,source_1) %>% 
  summarise(n=n()) %>% 
  ungroup() %>% 
  spread(source_1,n)

trail_class_leads %>% 
  group_by(date) %>% 
  summarise(n=n()) %>% 
  ggplot(mapping = aes(x=date,y=n))+
  geom_bar(stat = "identity")

temp <- trail_class_leads %>% 
  unite("ss",source_1,status,remove = FALSE) %>% 
  group_by(date,ss) %>% 
  summarise(n=n()) %>% 
  ungroup() %>% 
  spread(ss,n)
