library(dbplyr)
library(tidyverse)
library(RPostgreSQL)


# Prepare_data ------------------------------------------------------------

#LOAD_LOCALFILE
features<-read_delim('./columns.txt',delim = ',')
lession_stu<-read_csv('./lession_studentid.csv')
lession_stu$student_id=as.integer(lession_stu$student_id)

#ssh wuqiang@106.75.22.248 -L 5001:10.9.155.161:5432 -NnT
con <- DBI::dbConnect(RPostgreSQL::PostgreSQL(), 
                      host = '127.0.0.1',
                      user = "wuqiang",
                      port = 5001,
                      password = "wuqiang572",
                      dbname="furion")
student_personas<-tbl(con, "student_personas")

student_personas_lession<-student_personas %>% 
  select(as.factor(colnames(features))) %>% 
  filter(student_id %in% lession_stu$student_id) %>% 
  collect()
student_personas_lession$first_join_cls_time=as.Date(student_personas_lession$first_join_cls_time)

saveRDS(student_personas_lession,'./student_personas_lession.rds')
dbDisconnect(con)

#std,null, 
