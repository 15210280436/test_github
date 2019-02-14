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

student
