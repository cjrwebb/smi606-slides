library(tidyverse)
library(performance)

hate_groups <- read_csv("week-09-logistic-regression/slides/splc-hate-groups-2020.csv")

ideology_dummies <- hate_groups %>%
  sjmisc::to_dummy(Ideology, suffix = "label") %>% 
  as_tibble() %>% 
  janitor::clean_names()

hate_groups <- add_column(hate_groups, ideology_dummies) 

state_hate_groups <- hate_groups %>%
  mutate(
    hq = ifelse(Headquarters == "Yes", 1, 0),
    statewide = ifelse(Statewide == "Yes", 1, 0)
         ) %>%
  group_by(State, Ideology) %>%
  summarise_at(
    vars(hq, statewide, ideology_anti_immigrant:ideology_white_nationalist),
    ~ sum(., na.rm = TRUE)
  ) %>%
  ungroup() %>% 
  pivot_wider(
    names_from = Ideology,
    values_from = hq, names_prefix = "hq_"
  ) %>% 
  group_by(State) %>%
  summarise_all(
    ~sum(., na.rm = TRUE)
  ) %>% 
  janitor::clean_names() %>% 
  mutate_at(
    vars(hq_general_hate:hq_male_supremacy),
    ~ifelse(. > 0, 1, 0)
  )

state_hate_groups %>%
  summarise_at(vars(statewide:hq_male_supremacy), sum) %>%
  pivot_longer(cols = statewide:hq_male_supremacy) %>% view()


state_hate_groups <- state_hate_groups %>%
  select(
    -ideology_radical_traditional_catholicism,
    -ideology_neo_confederate,
    -ideology_male_supremacy,
    -hq_neo_confederate,
    -hq_male_supremacy,
    -hq_radical_traditional_catholicism
  )

names(state_hate_groups) <- str_replace(names(state_hate_groups), "ideology_", "n_")

state_hate_groups <- state_hate_groups %>%
  rename(
    n_statewide = statewide
  )

state_inequality <- read_csv("week-09-logistic-regression/slides/usa-inequality.csv")

anti_join(state_hate_groups, state_inequality, by = "state") 

combined_data <- left_join(state_hate_groups, state_inequality, by = "state") 

testmod <- glm(data = combined_data, 
               formula = hq_neo_nazi ~ 
                  high_school_drop_outs + trust + income_inequality, 
                family = binomial)

summary(testmod)

## Add poverty and ethnic diversity population?

poverty_us <- tibble::tribble(
                     ~state, ~x,  ~poverty, ~x2,
               "Alabama",  NA, 15.6,  NA,
                "Alaska",  NA, 10.2,  NA,
               "Arizona",  NA, 13.5,  NA,
              "Arkansas",  NA,   16,  NA,
            "California",  NA, 11.8,  NA,
              "Colorado",  NA,  9.4,  NA,
           "Connecticut",  NA,  9.9,  NA,
              "Delaware",  NA, 11.2,  NA,
  "District of Columbia",  NA, 14.1,  NA,
               "Florida",  NA, 12.7,  NA,
               "Georgia",  NA, 13.5,  NA,
                "Hawaii",  NA,    9,  NA,
                 "Idaho",  NA,   11,  NA,
              "Illinois",  NA, 11.4,  NA,
               "Indiana",  NA, 11.9,  NA,
                  "Iowa",  NA,   11,  NA,
                "Kansas",  NA, 11.3,  NA,
              "Kentucky",  NA,   16,  NA,
             "Louisiana",  NA, 18.8,  NA,
                 "Maine",  NA, 10.9,  NA,
              "Maryland",  NA,  9.1,  NA,
         "Massachusetts",  NA,  9.5,  NA,
              "Michigan",  NA, 12.9,  NA,
             "Minnesota",  NA,  8.9,  NA,
           "Mississippi",  NA, 19.5,  NA,
              "Missouri",  NA, 12.9,  NA,
               "Montana",  NA, 12.6,  NA,
              "National",  NA, 12.3,  NA,
              "Nebraska",  NA,  9.9,  NA,
                "Nevada",  NA, 12.7,  NA,
         "New Hampshire",  NA,  7.5,  NA,
            "New Jersey",  NA,  9.1,  NA,
            "New Mexico",  NA, 17.5,  NA,
              "New York",  NA, 13.1,  NA,
        "North Carolina",  NA, 13.6,  NA,
          "North Dakota",  NA, 10.5,  NA,
                  "Ohio",  NA,   13,  NA,
              "Oklahoma",  NA, 15.1,  NA,
                "Oregon",  NA, 11.5,  NA,
          "Pennsylvania",  NA,   12,  NA,
          "Rhode Island",  NA, 11.6,  NA,
        "South Carolina",  NA, 13.9,  NA,
          "South Dakota",  NA, 11.9,  NA,
             "Tennessee",  NA, 13.8,  NA,
                 "Texas",  NA, 13.6,  NA,
                  "Utah",  NA,  8.8,  NA,
               "Vermont",  NA, 10.1,  NA,
              "Virginia",  NA,  9.9,  NA,
            "Washington",  NA,  9.8,  NA,
         "West Virginia",  NA, 16.2,  NA,
             "Wisconsin",  NA, 10.4,  NA,
               "Wyoming",  NA,  9.9,  NA
  ) %>% select(-x, -x2)

anti_join(poverty_us, combined_data, by = "state")

combined_data <- left_join(poverty_us, combined_data, by = "state")

testmod <- glm(data = combined_data, 
               formula = hq_neo_nazi ~ 
                 high_school_drop_outs + poverty, 
               family = binomial)

summary(testmod)

testmod <- glm(data = combined_data, 
               formula = n_neo_nazi ~ 
                 high_school_drop_outs + poverty)

summary(testmod)

combined_data <- combined_data %>%
  mutate_at(
    vars(n_anti_immigrant:n_white_nationalist),
    list(mt1 = ~ifelse(. > 1, 1, 0))
  ) 


testmod <- glm(data = combined_data, 
               formula = n_neo_nazi_mt2 ~ 
                 high_school_drop_outs + poverty)

summary(testmod)

pop_data <- read_csv("week-09-logistic-regression/slides/2019_Census_US_Population_Data_By_State_Lat_Long.csv") %>%
  rename(state = STATE, population = POPESTIMATE2019) %>%
  mutate(population = population / 100000)

combined_data <- left_join(combined_data, pop_data, by = "state")

combined_data


testmod <- glm(data = combined_data, 
               formula = hq_neo_nazi ~ 
                 high_school_drop_outs + poverty + trust + population + lat,
               family = binomial(link = "logit"))

summary(testmod)

state_demos <- read_csv("week-09-logistic-regression/slides/state_demographics.csv") %>%
  janitor::clean_names() %>% # %>% names()
  select(
    state,
    age_percent_65_and_older,
    miscellaneous_percent_female,
    ethnicities_white_alone,
    ethnicities_black_alone,
    hous_value = housing_median_value_of_owner_occupied_units,
    income_median_houseold_income,
    housing_households_with_a_internet,
    education_bachelors_degree_or_higher,
    employment_firms_minority_owned
  ) %>%
  mutate(
    hous_value = hous_value / 100000
  )


combined_data <- left_join(combined_data, state_demos, by = "state")

combined_data <- combined_data %>%
  mutate(
    employment_firms_minority_owned = employment_firms_minority_owned / 100000
  )

janitor::tabyl(combined_data$n_neo_nazi_mt1)
janitor::tabyl(combined_data$n_general_hate_mt1)
janitor::tabyl(combined_data$n_anti_immigrant_mt1)
janitor::tabyl(combined_data$n_anti_lgbtq_mt1)
janitor::tabyl(combined_data$hq_general_hate)

testmod <- glm(data = combined_data, 
               formula = n_neo_nazi_mt1 ~
                 education_bachelors_degree_or_higher +
                 population + age_percent_65_and_older +
                 ethnicities_black_alone + housing_households_with_a_internet + lat,
               family = binomial(link = "logit"))

summary(testmod)

pdata <- predict(testmod, newdata = combined_data, type = "response")

caret::confusionMatrix(data = as.factor(as.numeric(pdata>0.5)), 
                       reference = as.factor(combined_data$n_neo_nazi_mt1))



testmod <- glm(data = combined_data, 
               formula = n_anti_immigrant_mt1 ~
                 education_bachelors_degree_or_higher +
                 population + age_percent_65_and_older +
                 ethnicities_black_alone + housing_households_with_a_internet + lat,
               family = binomial(link = "logit"))

summary(testmod)

voting <- read_csv("week-09-logistic-regression/slides/Popular vote backend - Sheet1.csv") %>%
  select(state, rep_percent) %>%
  mutate(rep_percent = parse_number(rep_percent))


anti_join(combined_data, voting, by = "state")

combined_data <- left_join(combined_data, voting, by = "state")

combined_data <- combined_data %>%
  mutate(
    rep_pop = rep_percent > 50
  )

testmod <- glm(data = combined_data, 
               formula = n_anti_immigrant_mt1 ~
                 population + ethnicities_black_alone + rep_pop + lat,
               family = binomial(link = "logit"))

summary(testmod)

testmod <- glm(data = combined_data, 
               formula = rep_pop ~
                 poverty + n_anti_immigrant_mt1 + population + ethnicities_black_alone + lat,
               family = binomial(link = "logit"))

summary(testmod)

write_csv(
  combined_data, "us_state_data_full.csv"
)

us_states_reduced <- combined_data %>%
  select(
    state,
    neo_nazi_hgs = n_neo_nazi_mt1,
    anti_imig_hgs = n_anti_immigrant_mt1,
    pc_bachelors_ed = education_bachelors_degree_or_higher,
    population,
    pc_age_65_plus = age_percent_65_and_older,
    pc_black_pop = ethnicities_black_alone,
    pc_hh_with_internet = housing_households_with_a_internet,
    latitude = lat,
    longitude = long
  )

us_states_reduced

write_rds(us_states_reduced, "hate_group_data.rds")

names_uss <- names(us_states_reduced)
labels_uss <- c("State",
            "Active Neo-Nazi hate groups in this state?",
            "Active anti-immigrant hate groups in this state?",
            "Percentage of the population with bachelors or higher education qualifications", 
            "Population (in 100,000s)",
            "Percentage of the population aged 65 or older",
            "Percentage of the population who identify as black",
            "Percentage of households with internet", 
            "Latitude (higher = more northern)",
            "Longitude (higher - more western)")

codebook <- tibble(names_uss, labels_uss)

write_csv(codebook, "week-09-logistic-regression/week-9-exercise/codebook.csv")

