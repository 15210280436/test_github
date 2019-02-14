library(RColorBrewer)
library(tidyverse)
RColorBrewer::display.brewer.all()

# In base R
(cols <- brewer.pal(n=5,name = "GnBu")) # 5表示YlOrRd颜色组用五个颜色显示从低到高
barplot(height=1:5,width = 1,col = cols)

# In ggolot2
library(magrittr)
library(ggplot2)

diamonds %>% 
  ggplot(aes(carat,price,col=cut)) +
  geom_point(alpha=.7)

diamonds %>% 
  ggplot(aes(carat,price,col=cut)) +
  geom_point(alpha=.7)+
  scale_color_brewer(palette = "GnBu")+
  theme_minimal()

diamonds %>% 
  select(cut,price) %>% 
  group_by(cut) %>% 
  summarise(avg=sum(price)/n(),price=sum(price),n=n())
