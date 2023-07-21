library(tidyverse)
library(haven)
library(labelled)
library(janitor)

lfs_2018 <- read_spss("lfs/spss/spss24/qlfs_js_2018_teach.sav") %>%
  labelled::unlabelled() %>%
  clean_names()

lfs_names <- names(lfs_2018)

lfs_labels <- var_label(lfs_2018)

codebook <- tibble(lfs_names, lfs_labels) %>% unnest()


lfs_2018
unique(lfs_2018$sexx)

hist(lfs_2018$grsswk)

hist(lfs_2018$hourpay)

hist(log(lfs_2018$grsswk))

set.seed(100)
lfs_2018_2 <- lfs_2018 %>%
  filter(grsswk < 1500)

hist(lfs_2018_2$grsswk)

# Restricted to people earning less than 1500 per week


lfs_2018_2 %>%
  sample_n(1000) %>%
  ggplot(aes(x = age, y = grsswk, colour = sexx)) +
  geom_point()


lfs_2018_2 %>%
  sample_n(1000) %>%
  ggplot(aes(x = ttushr, y = grsswk, colour = sexx)) +
  geom_point()


lfs_2018 %>%
  group_by(sexx) %>%
  summarise(mean(grsswk, na.rm = TRUE))

lm(data = lfs_2018_2, formula = ttushr ~ sexx) %>% summary()
lm(data = lfs_2018_2, formula = grsswk ~ ttushr) %>% summary()

lfs_2018_2 %>% 
  mutate(
    liv_bin = case_when(is.na(liv12w) ~ NA_real_,
                        liv12w == "Yes" ~ 1,
                        TRUE ~ 0),
    .after = liv12w
  ) %>% view()

# Select a limited number of variables for workshop - sample 1000


#  create simulated data for simpler in lecture examples



write_csv(codebook, "codebook.csv")
write_csv(lfs_2018_2, "lfs_sample.csv")
write_rds(lfs_2018, "lfs_2018.rds")
