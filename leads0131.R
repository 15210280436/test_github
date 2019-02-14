library(tidyverse)
library(ggthemes)
library(ggplot2)

leads <- readxl::read_xlsx("leads_0131.xlsx")

leads <- leads %>% 
  select(-X__2)

leads <- leads %>% 
  rename(
         type=SKU)

leads$type <- as.character(leads$type) #要求类型是char才能分类

leads <- leads %>% 
  mutate(leads_log=log(leads),active_log=log(active))

leads %>% 
  select(type,leads_log, active_log) %>% 
  gather(var, val, -type) %>% 
  ggplot(aes(val, fill = type)) + 
  geom_density(alpha = .5) +
  facet_wrap(~ var, scales = "free", ncol = 1) + 
  labs(x = "", y = "Density", fill = "type")

byType <- split(leads, leads$type)
t.test(byType$`1`$active_log, byType$`2`$active_log,alternative = "two.sided")
t.test(byType$`1`$leads_log, byType$`2`$leads_log,alternative = "two.sided")

