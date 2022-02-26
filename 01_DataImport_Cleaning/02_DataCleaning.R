View(geip17) ##gender equality italian parliament XVII legislature
library(stringr)

##check if I selected speeches in which 'donne/a' was mentioned, as I wanted

str_detect(geip17$argomento, "donn(e|a)")

##convert dates in a readable format 

library(lubridate)
geip17$data <- ymd(geip17$data)

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

##generate a new data frame with the variables in geip17 and 'gruppo_parl'
geip17gp <- cbind(geip17, gruppo_parl)
