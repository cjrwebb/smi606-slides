library(tidyverse)
library(haven)

wt_data <- read_spss("UKDA-7927-spss/spss/spss19/wtm_w3_data_final.sav") %>%
  labelled::unlabelled() %>%
  labelled::user_na_to_na()


wt_data <- wt_data %>%
  select(
    IndSer,
    ConspClim,
    ConspAlien,
    ConspMoon,
    Rsex,
    Rage,
    Hedqual_rec,
    HHincome,
    EverWk,
    Open1,
    Open2,
    Open3,
    Games,
    PscJb_rec,
    SciIntP_rec,
    Religious,
    gor_name,
    NSSEC3,
    Rurality,
    IMD_quartile,
    TrJourn,
    TrSciUn
  ) %>% janitor::clean_names()

var_labels <- labelled::var_label(wt_data, unlist = FALSE)

table(wt_data$open1)
table(as.numeric(wt_data$open1))

wt_data <- wt_data %>%
  mutate_at(
    vars(open1, open2, open3),
    list(nm = ~case_when(is.na(.) ~ NA_real_,
                          . == "Does not apply to me at all" ~ 0,
                          . == "Applies to me just a little" ~ 1,
                          . == "Applies to me a fair amount" ~ 2,
                          . == "Applies to me a great deal" ~ 3,
                        TRUE ~ NA_real_
                        )
    )
  ) %>%
  mutate(openness = round(rowMeans(across(open1_nm:open3_nm)), 2)) %>% 
  select(-open1_nm:-open3_nm) %>%
  mutate_at(vars(consp_clim:consp_moon),
    ~case_when(is.na(.) ~ NA_real_,
               . == "Definitely true" ~ 1,
               . == "Probably true" ~ 1,
               TRUE ~ 0)
  ) %>%
  mutate_if(
    is.factor,
    ~case_when(
              as.character(.) == "Refused" ~ NA_character_,
              as.character(.) == "Don't know" ~ NA_character_,
              as.character(.) == "Item not applicable" ~ NA_character_,
              TRUE ~ as.character(.)
              )
  )

labelled::var_label(wt_data) <- var_labels

view(wt_data)

wt_data <- wt_data %>% filter(rage < 200)

# Cut down trust and parent job label sizes. Refactor character variables.

janitor::tabyl(wt_data$hedqual_rec)
janitor::tabyl(wt_data$h_hincome)
janitor::tabyl(wt_data$ever_wk)
janitor::tabyl(wt_data$games)
janitor::tabyl(wt_data$psc_jb_rec)
janitor::tabyl(wt_data$sci_int_p_rec)
janitor::tabyl(wt_data$religious)
janitor::tabyl(wt_data$nssec3)
janitor::tabyl(wt_data$imd_quartile)
janitor::tabyl(wt_data$tr_journ)
janitor::tabyl(wt_data$tr_sci_un)

# Change rurality

wt_data <- wt_data %>%
  mutate(
    hedqual_rec = factor(hedqual_rec, levels = c("No qualifications",
                                                 "Level 1 qualifications",
                                                 "GCSEs/O levels",
                                                 "A levels",
                                                 "Higher education below degree",
                                                 "First degree",
                                                 "Postgraduate degree")),
    h_hincome = factor(h_hincome, levels = c("Less than £3,999",
                                             "£4,000 - £5,999",
                                             "£6,000 - £7,999",
                                             "£8,000 - £9,999",
                                             "£10,000 - £11,999",
                                             "£12,000 - £14,999",
                                             "£15,000 - £17,999",
                                             "£18,000 - £19,999",
                                             "£20,000 - £22,999",
                                             "£23,000 - £25,999",
                                             "£26,000 - £28,999",
                                             "£29,000 - £31,999",
                                             "£32,000 - £37,999",
                                             "£38,000 - £43,999",
                                             "£44,000 - £49,999",
                                             "£50,000 - £55,999",
                                             "£56,000 or more")),
    ever_wk = factor(ever_wk, levels = c("Yes", "No")),
    games = factor(games, levels = c("No", "Yes")),
    psc_jb_rec = case_when(is.na(psc_jb_rec) ~ NA_character_,
                           psc_jb_rec == "At least one parent has had scientific job" ~ "1+ Parent w/ Science Job",
                           TRUE ~ "Neither Parent w/ Science Job") %>% factor(., levels = c("Neither Parent w/ Science Job",
                                                                                            "1+ Parent w/ Science Job")),
    sci_int_p_rec = case_when(is.na(sci_int_p_rec) ~ NA_character_,
                              sci_int_p_rec == "Not very/not at all interesting" ~ "Not interested",
                              TRUE ~ "Interested") %>% factor(., levels = c("Not interested", "Interested")),
    religious = factor(religious, levels = c("No religion",
                                             "Religious - not practicing",
                                             "Religious - practicing")),
    nssec3 = factor(nssec3, levels = c("Managerial and professional occupations",
                                       "Intermediate occupations",
                                       "Routine and manual occupations",
                                       "Never worked and long-term unemployed")),
    imd_quartile = factor(imd_quartile, levels = c("First quartile (least deprived)",
                                                   "Second quartile",
                                                   "Third quartile",
                                                   "Fourth quartile (most deprived)")),
    tr_journ = case_when(is.na(tr_journ) ~ NA_character_,
                         tr_journ == "Complete trust" ~ "Trust",
                         tr_journ == "A great deal of trust" ~ "Trust",
                         tr_journ == "Some trust" ~ "Trust",
                         tr_journ == "Very little trust" ~ "Little/no trust",
                         tr_journ == "No trust at all" ~ "Little/no trust",
                         TRUE ~ NA_character_
                         ) %>% factor(., levels = c("Trust", "Little/no trust")),
    tr_sci_un = case_when(is.na(tr_sci_un) ~ NA_character_,
                          tr_sci_un == "Complete trust" ~ "Trust",
                          tr_sci_un == "A great deal of trust" ~ "Trust",
                          tr_sci_un == "Some trust" ~ "Trust",
                          tr_sci_un == "Very little trust" ~ "Little/no trust",
                          tr_sci_un == "No trust at all" ~ "Little/no trust",
                          TRUE ~ NA_character_
                            ) %>% factor(., levels = c("Trust", "Little/no trust")),
  ) 

labelled::var_label(wt_data) <- var_labels

wt_data <- wt_data %>%
  select(-open1:-open3)

wt_data <- wt_data %>%
  mutate(
    rurality = case_when(rurality == -1 ~ NA_character_,
                         rurality == 1 ~ "Urban",
                         rurality == 2 ~ "Rural"
                         ) %>%
               factor(., levels = c("Urban", "Rural"))
  )



write_rds(wt_data, file = "conspiracy.rds")

model_1 <- glm(data = wt_data,
    formula = consp_alien ~ rsex + rage + hedqual_rec + games + religious + psc_jb_rec,
    family = binomial(link = "logit"))

summary(model_1)

codebook <- tibble(
  varnames = names(wt_data),
  varlabels = c(labelled::var_label(wt_data, unlist = TRUE)[1:19], "Openness to new ideas/experiences scale (Higher = more openness)")
) %>%
  mutate(
    varlabels = ifelse(varnames == "rurality", "Area respondent lives in is rural or urban?", varlabels)
  )

write_csv(codebook, "conspiracy_codebook.csv")
