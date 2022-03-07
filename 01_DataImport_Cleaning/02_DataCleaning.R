##geip17 (gender equality italian parliament XVII legislature)---------------
library(here)
library(vroom)
library(stringr)
library(tidyverse)
library(lubridate)
library(tidytext)
library(tidyr)
library(tm)
geip17 <- vroom(here("Data.csv/geip17.csv"))

##convert dates in a readable format 

geip17$dataNascita <- ymd(geip17$dataNascita)
geip17$data_intervento <- ymd(geip17$data_intervento)
geip17$inizioIncarico <- ymd(geip17$inizioIncarico)
geip17$fineIncarico <- ymd(geip17$fineIncarico)

##check if I selected speeches in which 'donne/a' was mentioned, as I wanted

check_strings <- str_detect(geip17$argomento, "donn(e|a)")
check_strings

#I have some falses, so I need to check why and how to fix the problem

tm::stopwords("italian")
stop_words
stopwords

##list other words I don't want to include in the analysis

manual_swords <-  c("d", "n", "3", "2", "02428", "00538", 
                    "00544", "165", "7", "8", "00185", "90", "29", "00083", "1", 
                    "00065", "00042", "00043", "00041", "00040", "00036", "00039",
                    "90", "00110", "5", "00269", "01324", "04892", "00185", "00988",
                    "1556", "s", "1278", "3354", "3359", "0139", "10456", "9", "08834", "09428",
                    "281", "23", "00338", "00083", "01324", "00395", "10986",
                    "caradonna", "madonna", "Renato Di", "nonch")
comb_mswords <- c(manual_swords, stopwords(kind="it"))
comb_mswords

##create a data frame with all the stop words I don't want to include

manualswords <- tibble(
  x1=comb_mswords
)
manualswords

##split the variable 'argomento' into its single 'units of text' ('tokens'), in this case words
  
?unnest_tokens()

twowords <- geip17 %>% 
 select(argomento, genere) %>% 
    unnest_tokens(split_argomento, argomento, token="ngrams", n=2)

##split the column 'split_argomento' into its single words

twowords_sep <- twowords %>% 
  separate(split_argomento, c("parola1", "parola2"))

##remove stop words, and other words I don't want to include

filter2words <- twowords_sep %>% 
  filter(!parola1 %in% manualswords$x1) %>% 
  filter(!parola2 %in% manualswords$x1)

##recombine the columns 'parola1' and 'parola2' into one 

bigramsunited <- filter2words %>%
  unite(noswords, parola1, parola2, sep = " ")
bigramsunited

##filter bigramsunited to obtain a dataframe where only the pattern "donn[ea]" appears 
##in the column 'split_argomento' 

bigramsfilter <- bigramsunited %>% 
  filter(grepl(pattern="donn[ea]", noswords, ignore.case = TRUE))

##count the most common bigrams

bigrams_count <- bigramsfilter %>%
  count(noswords)
bigrams_count

##remove observations in which deputies don't talk about women

to_remove <- str_match_all(geip17$argomento, "Renato Di Donna|Salvatore Caradonna|Madonna")
to_remove

toremove <- tibble(
  x1=1:366,
  x2=to_remove
)
View(toremove)

geip17 <- filter(
  geip17,
  to_remove %in% "character(0)"
)
                 
##recode 'gruppo parlamentare'

table(geip17$gruppo_parlamentare)

##5stelle
m5s <- str_detect(geip17$gruppo_parlamentare, "STELLE")
m5s

##misto
mis <- str_detect(geip17$gruppo_parlamentare, "MISTO")
mis

##sinistra: articolo 1-movimento democratico e progressista, partito democratico, sinistra ecologia libertà, sinistra italiana
sx <- str_detect(geip17$gruppo_parlamentare, "SINISTRA|DEMOCRATICO")
sx

##centro: alternativa popolare-centristi per l'europa, per l'Italia
cen <- str_detect(geip17$gruppo_parlamentare, "CIVIC|POPOLARE|PER")
cen

##destra: forza italia-il popolo della libertà-Berlusconi presidente, fratelli d'Italia-alleanza nazionale, il popolo della libertà-Berlusconi presidente, lega nord e autonomie, nuovo centrodestra

dx <- str_detect(geip17$gruppo_parlamentare, "POPOLO|FRATELLI|LEGA|DESTRA")
dx

##generate the variable gruppo_parl with the parliamentary groups

gruppo_parl <- ifelse(m5s == TRUE,"Movimento 5 Stelle",
                             ifelse(mis == TRUE, "Misto",
                                    ifelse(sx == TRUE, "Sinistra",
                                           ifelse(cen==TRUE, "Centro",
                                                 ifelse(dx==TRUE, "Destra",
                                                        "altro")))))

gruppo_parl

##chek if I miss some categories 
str_which(gruppo_parl, "altro")

##add 'gruppo_parl' to the data frame geip17
geip17$gruppo <- gruppo_parl
with(geip17, table(gruppo_parlamentare, gruppo_parl))


##tot2015---------------------------------

tot2015 <- vroom(here("Data.csv/tot2015.csv"))

##recode dates

tot2015$data_intervento <- ymd(tot2015$data_intervento)
tot2015$inizioIncarico <- ymd(tot2015$inizioIncarico)
tot2015$fineIncarico <- ymd(tot2015$fineIncarico)

##recode "argomento": 0=the deputy didn't talk about women, 1=the deputy told about women

match <- str_match_all(tot2015$argomento, "donn(e|a)")

tibble_match <- tibble(
  x1=1:58086,
  x2=match
)
tot2015$donne <- ifelse(match %in% "character(0)", 0, 1)

##check if I need to remove cases in which the deputy didn't talk about women, 
##even if the pattern donne[ea] appears in the variable 'argomento'

str_which(tot2015$argomento, "madonna|caradonna|di donna")

prop.table(table(tot2015$genere, tot2015$donne), margin=1)

##recode gruppo parlamentare

m5s <- str_detect(tot2015$gruppo_parlamentare, "STELLE")
m5s

##misto
mis <- str_detect(tot2015$gruppo_parlamentare, "MISTO")
mis

##sinistra: articolo 1-movimento democratico e progressista, partito democratico, sinistra ecologia libertà, sinistra italiana
sx <- str_detect(tot2015$gruppo_parlamentare, "SINISTRA|DEMOCRATICO")
sx

##centro: alternativa popolare-centristi per l'europa, per l'Italia
cen <- str_detect(tot2015$gruppo_parlamentare, "CIVIC|POPOLARE|PER")
cen

##destra: forza italia-il popolo della libertà-Berlusconi presidente, fratelli d'Italia-alleanza nazionale, il popolo della libertà-Berlusconi presidente, lega nord e autonomie, nuovo centrodestra

dx <- str_detect(tot2015$gruppo_parlamentare, "POPOLO|FRATELLI|LEGA|DESTRA")
dx

##generate the variable gruppo_parl with the parliamentary groups

gruppo_parl <- ifelse(m5s == TRUE,"Movimento 5 Stelle",
                      ifelse(mis == TRUE, "Misto",
                             ifelse(sx == TRUE, "Sinistra",
                                    ifelse(cen==TRUE, "Centro",
                                           ifelse(dx==TRUE, "Destra",
                                                  "altro")))))

gruppo_parl

##chek if I miss some categories 
str_which(gruppo_parl, "altro")

##add 'gruppo_parl' to the data frame tot2015
tot2015$gruppo <- gruppo_parl
with(tot2015, table(gruppo_parlamentare, gruppo_parl))

##recode gender in order to have a numeric variable

tot2015$num.gender <- ifelse(tot2015$genere == "male", 1, 0)
table(tot2015$genere, tot2015$donne)

