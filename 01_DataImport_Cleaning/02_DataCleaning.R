View(geip17) ##gender equality italian parliament XVII legislature
library(stringr)
library(tidyverse)

geip17$argomento

##convert dates in a readable format 

library(lubridate)
geip17$dataNascita <- ymd(geip17$dataNascita)
geip17$data_intervento <- ymd(geip17$data_intervento)
geip17$inizioIncarico <- ymd(geip17$inizioIncarico)
geip17$fineIncarico <- ymd(geip17$fineIncarico)

##check if I selected speeches in which 'donne/a' was mentioned, as I wanted

check_strings <- str_detect(geip17$argomento, "donn(e|a)")
check_strings

#I have some falses, so I need to check why and how to fix the problem

install.packages("tidytext")
library(tidytext)
library(tidyr)
install.packages("tm")
library(tm)
tm::stopwords("italian")
stop_words
stopwords

stopwords(kind="it")
swords <- tibble(
  x1=1:279,
  x2=stopwords(kind="it")
)
swords

manual_swords <-  c("d", "n", "3", "2", "02428", "00538", "00544")
comb_mswords <- c(manual_swords, stopwords(kind="it"))
comb_mswords


manualswords <- tibble(
  x1=1:286,
  x2=comb_mswords
)
manualswords

##split the variable 'argomento' into its single words ('tokens')
  
?unnest_tokens()

twowords <- geip17 %>% 
 select(argomento, data_intervento) %>% 
    unnest_tokens(split_argomento, argomento, token="ngrams", n=2)

##filter twowords only when the pattern "donn[ea]" appears in the column 'split_argomento' 

twordsfilter <- twowords %>% 
  filter(grepl(pattern="donn[ea]", split_argomento))

##separate the column 'split_argomento' into its single words

twordsfilter_sep <- twordsfilter %>% 
  separate(split_argomento, c("parola1", "parola2"))

##remove stop words

noswords <- twordsfilter_sep %>% 
  filter(!parola1 %in% manualswords$x2) %>% 
  filter(!parola2 %in% manualswords$x2)

##see which are the words which are the most commonly paired with 'donna/e'

noswords %>%
  count(parola1, parola2, sort=TRUE)

##Renato Di Donna
##salvatore caradonna
##madonna 

str_subset(geip17$argomento, "Renato Di Donna", negate=FALSE) ##12
str_subset(geip17$argomento, "Salvatore Caradonna", negate=FALSE) ##3
str_subset(geip17$argomento, "Madonna", negate=FALSE) ##9

##da rivedere
geip17filter <- geip17 %>% 
  filter(!argomento %in% c("Renato Di Donna", "Salvatore Caradonna", "Madonna"))

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
str_detect(gruppo_parl, "altro")

##add 'gruppo_parl' to the data frame geip17
geip17$gruppo <- gruppo_parl
with(geip17, table(gruppo_parlamentare, gruppo_parl))

geip17$num.gender <- ifelse(geip17$genere == "male", 1, 0)
table(geip17$num.gender, geip17$genere)
