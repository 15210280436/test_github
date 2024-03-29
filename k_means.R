library(tidyverse)
library(ggthemes) # for plot theme
library(janitor) # for clean name
library(cluster) # for cluster algos
library(gridExtra) # for putting multiple plots together
library(factoextra) # extra help on clustering visualization
library(DT) # for interactive

# set plot theme
old <- theme_set(theme_tufte() + theme(text = element_text(family = "Menlo")))

# discount information
offers <- read_csv("https://query.data.world/s/ixq45avtsmixmx4awbjuaueeaono7t") %>% clean_names()
offers

# orders information
orders <- read_csv("https://query.data.world/s/hbzvqhg2iqtdhgzmi3k5jmvy3xeeph") %>% clean_names()
orders

# convert orders to matrix
mm <- orders %>% 
  mutate(purchase = 1) %>% 
  spread(customer_last_name, purchase, fill = 0) %>% 
  select(-offer_number) %>% 
  data.matrix() 

# set k = 2 
km.2 <- kmeans(mm, centers = 2, iter.max = 50, nstart = 20)

# view structure
str(km.2)

# visualise cluster
offers %>% 
  mutate(cluster = factor(km.2$cluster)) %>% 
  ggplot(aes(origin, varietal, col = cluster)) + 
  geom_point()

# try different cluster numbers
set.seed(1212)
k <- 2:10
km <- map(k, ~ kmeans(mm, centers = .x, iter.max = 50, nstart = 20))

# collect plots using iteration
display_cluster <- function(vec) {
  offers %>% 
    mutate(cluster = factor(vec)) %>% 
    ggplot(aes(origin, varietal, col = factor(vec))) + 
    geom_point() + 
    scale_color_discrete(guide = 'none') + 
    labs(x = "", y = "", col = "") + 
    theme(text = element_text(size = 1))
}
p <- map(km, ~ display_cluster(.x$cluster))

# open in Quartz, NOT in Rstudio 
marrangeGrob(p, nrow = 3, ncol = 3)

# the elbow method
plot(k, map_dbl(km, "tot.withinss"), type = "b", 
     frame = FALSE, 
     xlab = "# Clusters, k",
     ylab = "Total Within SS")

# alternative
fviz_nbclust(mm, kmeans, method = "wss")

# extract silhouette and calc mean
avg_sil <- function(k, dist_mat) {
  ss <- silhouette(k, dist_mat)
  mean(ss[, 3])
}
plot(k, map_dbl(km, ~ avg_sil(.x$cluster, dist(mm))), type = "b")

# alternative
fviz_nbclust(mm, kmeans, method = "silhouette")

# use optimal clusters
set.seed(1212)
km.6 <- kmeans(mm, centers = 6, iter.max = 50, nstart = 20)

# convert to DataTable
offers %>% 
  mutate(cluster = km.6$cluster) %>% 
  DT::datatable(options = list(pageLength = 50, dom = 'tip'), 
                filter = 'top')