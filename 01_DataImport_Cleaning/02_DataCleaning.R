View(geip17) ##gender equality italian parliament XVII legislature
library(stringr)
library(tidyverse)

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

##create a data frame with italian stopwords

stopwords(kind="it")
swords <- tibble(
  x1=1:279,
  x2=stopwords(kind="it")
)
swords

##list other words I don't want to include in the analysis

manual_swords <-  c("d", "n", "3", "2", "02428", "00538", 
                    "00544", "caradonna", "madonna", "Renato Di", "nonch")
comb_mswords <- c(manual_swords, stopwords(kind="it"))
comb_mswords

##add this vector to the previously defined data frame

manualswords <- tibble(
  x1=comb_mswords
)
manualswords

##split the variable 'argomento' into its single 'units of text' ('tokens'), in this case words
  
?unnest_tokens()

twowords <- geip17 %>% 
 select(argomento, genere) %>% 
    unnest_tokens(split_argomento, argomento, token="ngrams", n=2)

##filter twowords to obtain a dataframe where only the pattern "donn[ea]" appears 
##in the column 'split_argomento' 

twowordsfilter <- twowords %>% 
  filter(grepl(pattern="donn[ea]", split_argomento,ignore.case = TRUE))

##split the column 'split_argomento' into its single words

twowordsfilter_sep <- twowordsfilter %>% 
  separate(split_argomento, c("parola1", "parola2"))

##remove stop words, "caradonna", "madonna", "Renato Di Donna"

noswords <- twowordsfilter_sep %>% 
  filter(!parola1 %in% manualswords$x1) %>% 
  filter(!parola2 %in% manualswords$x1)

##recombine the columns 'parola1' and 'parola2' into one 

bigrams_united <- noswords %>%
  unite(noswords, parola1, parola2, sep = " ")
bigrams_united

##count the most common bigrams

bigrams_count <- bigrams_united %>%
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
str_detect(gruppo_parl, "altro")

##add 'gruppo_parl' to the data frame geip17
geip17$gruppo <- gruppo_parl
with(geip17, table(gruppo_parlamentare, gruppo_parl))

geip17$num.gender <- ifelse(geip17$genere == "male", 1, 0)
table(geip17$num.gender, geip17$genere)
