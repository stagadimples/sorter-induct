
# load libraries
library(tidyverse); library(lubridate)

dt <- read.table("data-raw/peak.txt", header = T, sep = ",", stringsAsFactors = F)

names(dt) <- tolower(names(dt))


containers <- dt %>%
  filter(container_class != 'SAP MP2') %>%
  group_by(container_class, area) %>%
  summarise(parcels = n_distinct(shipping_lpn)) %>%
  arrange(container_class, area) %>%
  as.data.frame()