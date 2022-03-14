##geip17 (gender equality italian parliament XVII legislature)---------------
library(here)
library(vroom)
library(lubridate)
library(tidytext)
library(tidyr)
library(tm)
library(dplyr)
geip17 <- vroom(here("Data.csv/geip17.csv"))

##convert dates in a readable format 

geip17$dataNascita <- ymd(geip17$dataNascita)
geip17$data_intervento <- ymd(geip17$data_intervento)
geip17$inizioIncarico <- ymd(geip17$inizioIncarico)
geip17$fineIncarico <- ymd(geip17$fineIncarico)

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

gruppo_parl <- ifelse(m5s == TRUE,"M5S",
                      ifelse(mis == TRUE, "Misto",
                             ifelse(sx == TRUE, "Sinistra",
                                    ifelse(cen==TRUE, "Centro",
                                           ifelse(dx==TRUE, "Destra",
                                                  "altro")))))


##chek if I miss some categories 
str_which(gruppo_parl, "altro")

##replace the new categories of 'gruppo_parl' in 'gruppo_parlamentare'
geip17$gruppo_parlamentare <- gruppo_parl

##check if I selected speeches in which 'donne/a' was mentioned, as I wanted

check_strings <- str_detect(geip17$argomento, "donn(e|a)")
check_strings

#I have some falses, so I need to remove observations in which deputies don't talk about women

to_remove <- str_match_all(geip17$argomento, "Renato Di Donna|Salvatore Caradonna|Madonna")
to_remove

to_remove <- tibble(
  x1=1:366,
  x2=to_remove
)

geip17 <- filter(
  geip17,
  to_remove$x2 %in% "character(0)"
)

##tot2015---------------------------------

tot2015 <- vroom(here("Data.csv/tot2015.csv"))

##recode dates

tot2015$data_intervento <- ymd(tot2015$data_intervento)
tot2015$inizioIncarico <- ymd(tot2015$inizioIncarico)
tot2015$fineIncarico <- ymd(tot2015$fineIncarico)

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

gruppo_parl <- ifelse(m5s == TRUE,"M5S",
                      ifelse(mis == TRUE, "Misto",
                             ifelse(sx == TRUE, "Sinistra",
                                    ifelse(cen==TRUE, "Centro",
                                           ifelse(dx==TRUE, "Destra",
                                                  "altro")))))

gruppo_parl

##chek if I miss some categories 
str_which(gruppo_parl, "altro")

##replace the new categories of 'gruppo_parl' in 'gruppo_parlamentare'
tot2015$gruppo_parlamentare <- gruppo_parl
table(tot2015$gruppo_parlamentare)

##recode "argomento" in two categories: the deputy didn't talk about women/the deputy told about women

match <- str_match_all(tot2015$argomento, "donn(e|a)")

tibble_match <- tibble(
  x1=1:58086,
  x2=match
)
tot2015$argomento <- ifelse(match %in% "character(0)", "any topic", "women rights/gender equality")
table(tot2015$argomento)

##check if I need to remove cases in which the deputy didn't talk about women, 
##even if the pattern donne[ea] appears in the variable 'argomento'

str_which(tot2015$argomento, "madonna|caradonna|di donna")

##integer(0) => I don't


###-----not explained in the report---------

prop.table(table(tot2015$genere, tot2015$argomento), margin=1)

##recode gender in order to have a numeric variable

tot2015$num.gender <- ifelse(tot2015$genere == "male", 1, 0)
table(tot2015$genere, tot2015$argomento)

