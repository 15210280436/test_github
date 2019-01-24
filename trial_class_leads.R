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

leads <- readxl::read_xlsx("leads.xlsx")

leads <- leads %>% 
  rename(
  
  month=月
)

leads_0 <- leads %>% 
  group_by(month,city_level) %>% 
  summarise(n=n()) %>% 
  ungroup() %>% 
  spread(city_level,n) 

leads_1 <- leads %>% 
  group_by(month) %>% 
  summarise(n=n())

leads_2 <- inner_join(leads_0,leads_1)
leads_2 <- leads_2 %>% 
  rename(
    a1=`1`,
    a2=`2`,
    a3=`3`,
    a4=`4`,
    a5=`5`
    
    
  )
leads_2 %>% 
  mutate(a1_rate=leads_2$a1/n,a2_rate=leads_2$a2/n,a3_rate=leads_2$a3/n,a4_rate=leads_2$a4/n,a5_rate=leads_2$a5/n)
