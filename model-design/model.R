
# load libraries
library(tidyverse); library(lubridate)

dt <- read.table("data-raw/rawdata.txt", header = T, sep = ",", stringsAsFactors = F)

names(dt) <- tolower(names(dt))

sorter <- dt %>%
  select(order_no, customer_selling_system_no, shipping_barcode, pack_user,
         area_packed, handling_type, classification, area_type, units, products,
         sorter_time) %>%
  mutate(sorter_time = ymd_hms(sorter_time), hr = hour(sorter_time),
         htype = ifelse(handling_type == 'SmallFinishingCartonNano', 'Nano', classification)) %>%
  group_by(hr) %>%
  summarise(bagging = n_distinct(if_else(htype == "Bagging Line", shipping_barcode, NULL)),
            lpc = n_distinct(if_else(htype == "Large Carton Line", shipping_barcode, NULL)),
            mpc = n_distinct(if_else(htype == "MediumPickingCarton", shipping_barcode, NULL)),
            mpcl = n_distinct(if_else(htype == "MediumPickingCartonLarge", shipping_barcode, NULL)),
            pb = n_distinct(if_else(htype == "Pack Bench", shipping_barcode, NULL)),
            hpb = n_distinct(if_else(htype == "Hanging Pack Bench", shipping_barcode, NULL)),
            scl = n_distinct(if_else(htype == "Carton Finishing Line", shipping_barcode, NULL)),
            nano = n_distinct(if_else(htype == "Nano", shipping_barcode, NULL)),
            parcels = n_distinct(shipping_barcode)
            )


# Get relative proportions per hour

sorter_rl <- cbind(sorter$hr, sorter[2:(ncol(sorter) - 1)] / rowSums(sorter[2:(ncol(sorter) - 1)]))

# Average hourly proportion by carton type
max_prop <- (sorter_rl[which.max(sorter$parcels), ])
max_vals <- sorter[which.max(sorter$parcels), ]
max_vals # parcels at peak hour 


# convert to long format

sorter_lf <- gather(sorter, key = 'description', value = 'parcels', select = -hr)
sorter_lf$description <- factor(sorter_lf$description)

# Parcels per hour (Line chart)
sorter_lf %>%
  filter(description != 'parcels') %>%
  ggplot(aes(x = hr, y = parcels)) +
  geom_line(aes(colour = description), size = 1)


# Distribution of parcels per carton type (Boxplot)
sorter_lf %>%
  filter(description != 'parcels') %>%
  ggplot(aes(x = description, y = parcels)) +
  geom_boxplot(aes(colour = description), size = 1)

# Units Per Parcel

upp <- sorter_lf %>%