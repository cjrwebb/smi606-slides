library(tidyverse)
library(janitor)
library(readxl)

pop04 <- read_csv("dwp-0-4.csv", skip = 9) %>%
  select(-6) %>%
  filter(Year == "Mid-2020") %>%
  select(la_name = `National - Regional - LAs`, pop = Count) %>%
  drop_na()

pop59 <- read_csv("dwp-5-9.csv", skip = 9) %>%
  select(-6) %>%
  filter(Year == "Mid-2020") %>%
  select(la_name = `National - Regional - LAs`, pop = Count) %>%
  drop_na()

pop1014 <- read_csv("dwp-10-14.csv", skip = 9) %>%
  select(-6) %>%
  filter(Year == "Mid-2020") %>%
  select(la_name = `National - Regional - LAs`, pop = Count) %>%
  drop_na()

pop15 <- read_csv("dwp-15.csv", skip = 9) %>%
  select(-6) %>%
  filter(Year == "Mid-2020") %>%
  select(la_name = `National - Regional - LAs`, pop = Count) %>%
  drop_na()

population <- left_join(pop04, pop59, by = c("la_name")) %>%
  left_join(., pop1014, by = c("la_name")) %>%
  left_join(., pop15, by = c("la_name")) %>%
  mutate(pop_0_16 = rowSums(across(pop.x:pop.y.y))) %>%
  select(la_name, pop_0_16)

poverty <- read_csv("dwp-rli.csv", skip = 8) %>%
  select(la_name = Year, n_pov = `2020/21 (p)`) %>%
  drop_na()

poverty <- left_join(poverty, population, by = c("la_name")) %>%
  mutate(
    child_poverty_rate = (as.numeric(n_pov) / as.numeric(pop_0_16))*100
  ) %>%
  select(-n_pov, -pop_0_16) %>%
  rename(la_code = la_name)


homeless_rate <- read_xlsx("homelessness_lad.xlsx", sheet = "A1", skip = 3) %>%
  select(la_code = 1, la_name = 2, homelessless_per_10k = 16) %>%
  drop_na() %>%
  mutate(homelessless_per_10k = as.numeric(homelessless_per_10k)*10)

anti_join(poverty, homeless_rate, by = c("la_code")) 

dwp_mhclg_data <- left_join(poverty, homeless_rate, by = c("la_code")) %>% 
  relocate(la_name, .before = child_poverty_rate)

write_csv(dwp_mhclg_data, "dwp-mhclg-dat.csv")





