## Allison Park
## QBS 181: Data Wrangling Final Exam (R)

library(RODBC)
library(dplyr)
library(sqldf)
library(tidyverse)

## Question 1d.
# connecting to SQL
myconn<-odbcConnect("QBS181","hpark","hpark@qbs181")

# Taking the merged Demographics and BP dataset from SQL
Demo_BP <- sqlQuery(myconn, "select * from hpark.Demo_BP")
Demo_BP2 <- Demo_BP[!is.na(Demo_BP$tri_enrollmentcompletedate),]
Demo_BP2 <- Demo_BP[Demo_BP$tri_enrollmentcompletedate!= 'NULL',]
Demo_BP2$ObservedTime <- as.Date(Demo_BP2$ObservedTime,origin = "1899-12-30")
Demo_BP2$tri_enrollmentcompletedate <- as.Date(Demo_BP2$tri_enrollmentcompletedate, format = "%m/%d/%Y")

# Data for interval 0~12 weeks
Demo_BP3 <- Demo_BP2 %>% 
  group_by(contactid) %>% 
  arrange(ObservedTime, .by_group = TRUE) %>%
  filter(difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")<12) %>% # time interval
  summarize(difftime = difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks"),
         mean_sys = mean(SystolicValue, na.rm = TRUE),
         mean_dia = mean(Diastolicvalue, na.rm = TRUE), .groups = "keep") 

# Data for interval 13~24 weeks
Demo_BP4 <- Demo_BP2 %>% 
  group_by(contactid) %>% 
  arrange(ObservedTime, .by_group = TRUE) %>%
  filter(difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")> 12 &
           difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")<=24) %>%
  summarize(difftime = difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks"),
         mean_sys = mean(SystolicValue, na.rm = TRUE),
         mean_dia = mean(Diastolicvalue, na.rm = TRUE), .groups = "keep")

# Data for interval 25~36 weeks
Demo_BP5 <- Demo_BP2 %>% 
  group_by(contactid) %>% 
  arrange(ObservedTime, .by_group = TRUE) %>%
  filter(difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")>25,
         difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")<=36) %>%
  summarize(difftime = difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks"),
            mean_sys = mean(SystolicValue, na.rm = TRUE),
            mean_dia = mean(Diastolicvalue, na.rm = TRUE), .groups = "keep") 

# Data for interval 36~47 weeks
Demo_BP6 <- Demo_BP2 %>% 
  group_by(contactid) %>% 
  arrange(ObservedTime, .by_group = TRUE) %>%
  filter(difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")>36,
         difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")<=49) %>%
# Weeks 48 and 49 included within this category for data simplicity
  summarize(difftime = difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks"),
            mean_sys = mean(SystolicValue, na.rm = TRUE),
            mean_dia = mean(Diastolicvalue, na.rm = TRUE), .groups = "keep") 
  
# printing ten random rows for first interval (example)
Demo_BP3[sample(nrow(Demo_BP3), 10), ]


## Question 1e.
#datasets for comparison of week 1 and week 12
compare1 <- Demo_BP2 %>% 
  group_by(contactid) %>% 
  arrange(ObservedTime, .by_group = TRUE) %>%
  filter(difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")<2)%>%
  summarize(mean_sys = mean(SystolicValue, na.rm = TRUE),
            mean_dia = mean(Diastolicvalue, na.rm = TRUE), .groups = "keep")
compare2 <- Demo_BP2 %>% 
  group_by(contactid) %>% 
  arrange(ObservedTime, .by_group = TRUE) %>%
  filter(difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")>=12,
         difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")<13) %>%
  summarize(mean_sys = mean(SystolicValue, na.rm = TRUE),
            mean_dia = mean(Diastolicvalue, na.rm = TRUE), .groups = "keep")
# comparison for mean systolic value
compare_systolic <- compare1$mean_sys-compare2$mean_sys
# comparison for mean diastolic value
compare_diastolic <- compare1$mean_dia-compare2$mean_dia
compare <- cbind(compare1$contactid, compare_systolic, compare_diastolic)

# printing ten random rows
compare[sample(nrow(compare), 10), ]


## Question 1f.
#datasets for comparison of week 1 and week 12
compare_1 <- Demo_BP2 %>% 
  arrange(ObservedTime) %>%
  filter(difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")<2) %>%
  count(BPStatus1)
compare_12 <- Demo_BP2 %>% 
  arrange(ObservedTime) %>%
  filter(difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")>=12,
         difftime(ObservedTime, tri_enrollmentcompletedate, units = "weeks")<13) %>%
  count(BPStatus1)
# count of BP Status in week 12
compare_12

## Question 3
# connecting to SQL
myconn<-odbcConnect("QBS181","hpark","hpark@qbs181")

# Taking Demographics, Conditions, Text tables to be merged
Demographics <- sqlQuery(myconn, "select * from Demographics")
Conditions <- sqlQuery(myconn, "select * from Conditions")
Text <- sqlQuery(myconn, "select * from Text")

merged_DC <- merge(Demographics, Conditions, by.x = "contactid", by.y = "tri_patientid")
merged_DCT <- merge(merged_DC, Text, by.x = "contactid", by.y = "tri_contactId")  # Three data sets merged


# Part 2 Final data set: Keeping only the row per ID with the latest date that the text was sent
merged_DCT2 <- merged_DCT %>% 
  group_by(contactid) %>%
  slice(which.max(TextSentDate))  # selecting by the grouped data frame and keeping the max

# printing ten random rows
merged_DCT2[sample(nrow(merged_DCT2), 10), ]

