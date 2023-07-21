library(modeest)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(datasets)
library(janitor)
       
       
mps_sale <- read.csv("MPs.csv")
mps_sale

#147 rows, and 10 columns
dim(mps_sale)

#type of data in mps
class(mps_sale)

#Gives me all the variable names
names(mps_sale)
summary(mps_sale)
summary(mps_sale$party)

#' CW: Looks like this should be ln.gross rather than In.gross - 
#' easy mistake to make

# Original code
mean_all <- mean(mps_sale$In.gross, na.rm = TRUE)


#' CW Added code:
mean_all <- mean(mps_sale$ln.gross, na.rm = TRUE)
mean_all
# End of added code

in.gross <- mps_sale$ln.gross
in.gross

summary(in.gross)

party <- mps_sale$party
party


birth <- mps_sale$yob
birth

#' CW Comment: dplyr's filter only applies to entire datasets rather than
#' vectors
filter(birth, date >= as.Date ("1950"), date <= as.Date ("1970"))

#' CW Added code:
#' You would generally filter the entire dataset, e.g.

mps_sale %>%
  filter(yob >= 1950 & yob <= 1970)

#' However, in this case we don't actually have any observations with
#' year of birth within this range. I believe this is because this data 
#' was on MPS running for election in the 70s, so they would have either
#' been very young or babies. If we try an earlier date range it works.

mps_sale %>%
  filter(yob >= 1920 & yob <= 1930)

#' If you really need to subset a vector (e.g. the object birth), you can
#' use either subset() or you can subset using square brackets

birth[birth >= 1920 & birth <= 1930] 

subset(birth, subset = birth >= 1920 & birth <= 1930)

#' Note that subset removes NAs (because technically NA is not between)
#' those numbers, but [] subsetting retains NA.
#' 
#' End of added code

mps_sale %>%
  select(party, yob) %>%
  summary(.)

mps_sale %>%
  select(yod) %>%
  summary(.)

library(stringr)

tory <- mps_sale %>%
  select(party, yob, yod, firstname, surname,) %>%
  filter(party == "tory")
  summary(tory)

#' CW Comment: Above code is missing a %>% symbol, has
#' an excess comma
#' probably should be:
#' CW Added code:

tory <- mps_sale %>%
  select(party, yob, yod, firstname, surname) %>%
  filter(party == "tory") 
summary(tory)
  
#' End of added code
  
# CW Comment: in.gross should be ln.gross
mean(mps_sale$in.gross, na.rm = TRUE)
class(in.gross)

# CW added code:
mean(mps_sale$ln.gross, na.rm = TRUE)
# End added code


#' CW comment: first name should be firstname (no spaces in variable names 
#' unless they are wrapped by a ``).
#' Further - do not need the firstname argument in str_detect.
#' Also - in.net and in.gross should be ln.net and ln.gross
tory <-mps_sale %>%
  select("surname", "first name", "party", "in.gross", "in.net", "yob", "yod") %>%
  filter(str_detect(party, "tory", firstname))
  tory <- filter(party == "tory")
tory

#' CW amended code:
tory <-mps_sale %>%
  select("surname", "firstname", "party", "ln.gross", "ln.net", "yob", "yod") %>%
  filter(str_detect(party, "tory"))

#' Filter is already applied here, so I would remove this 
# --- REMOVED LINE    tory <- filter(party == "tory")
tory

#' End of amended code

dim(tory)


#' CW comment - No file named this yet in the data, hence error,
#' Maybe you read it in later but wrote this code earlier? Or read
#' in through the console?
summary(MPs)
dim(MPs)

#Descriptive Statistics for ALL MP's in MPs

mean(MPs$ln.gross, na.rm = TRUE)
median(MPs$ln.gross)
mode(MPs$ln.gross)

MPs %>%
  skim(party, in.gross)
  


#' CW comment - again, above did not run because the object MPs wasn't 
#' yet defined. Maybe it should have been mps_sale?
#' You also did not yet load the skimr package
#' e.g.
#' CW Added code:

library(skimr)
mps_sale %>%
  skim(party, ln.gross)

# End of added code



#' CW comment - remove pipe as it's currently overwriting the data with the summary
#' Otherwise it's good!
newdata <- subset(mps_sale, party = "tory", select=c(surname, firstname, party)) #%>%
# pipe above commented out

#' CW added code:
#' 
newdata <- subset(mps_sale, party = "tory", select=c(surname, firstname, party))
# End of added code

summary(newdata)

as_tibble(tory)

library(janitor)


mps_sale %>%
  select(party) %>% 
  summary(.)

mps_sale %>%
  tabyl(party)

new_data_frame <- data.frame()

library(skimr)

# CW comment: wrong way around %>% rather than >%>
# Also should be ln.gross rather than in.gross and
# should be mps_sale not mps_sales
mps_sales >%>
  skim(in.gross)

# CW added code: 
mps_sale %>%
  skim(ln.gross)
# End added code

# CW Comment: See above, no object named this so I just get an error so 
#' cannot comment on the below! Sorry!
MPs %>%
  tabyl(party) %>%
  filter(party == "tory")

mp_party_data <- MPs[c(1, 2, 3)]
mp_party_data

mp_party_data_2 <- MPs %>%
  filter("tory" == TRUE)
mp_party_data_2

tibble(mp_party_data_2)

# Create a bar chart for numer of Labour and Tory Mp's
ggplot(data = MPs) +
  geom_bar(aes( x = party)) +
  ggtitle(" Labour or Death")


ggplot(data = MPs) +
  geom_bar(aes( x = region, fill = party))
  ggtitle("Regional Representation")
  
tory <-MPs %>%
    MPs[c(1,2,3,4,5,6,7,8,9,10)] %>%
    filter(party, == "tory")
tory

summary(tory)
class(tory)

tory
dim(tory)

tory %>%
  mean(tory$)


  















