library(dplyr)
library(stringr)
library(SPARQL)

url <- "http://dati.camera.it/sparql"

query <- "SELECT DISTINCT ?argomento ?nome ?cognome ?genere ?gruppo_parlamentare ?background ?inizioIncarico ?fineIncarico ?data_intervento ?intervento ?discussione
WHERE  {
  {
    SELECT DISTINCT ?argomento ?nome ?cognome ?genere ?gruppo_parlamentare ?background ?inizioIncarico ?fineIncarico ?data_intervento ?intervento ?discussione
                      WHERE  {
##define the variable 'dibattito' and select all those which belong to the XVII legislature. 
##define the variable 'discussione' starting from the variable 'dibattito'
	?dibattito a ocd:dibattito;
                 ocd:rif_leg <http://dati.camera.it/ocd/legislatura.rdf/repubblica_17>.
    ?dibattito ocd:rif_discussione ?discussione.

##define the variable 'argomento' starting from 'discussione'. Ask for 'data_intervento',
##which will be useful to fix a bug 
 
  ?discussione ocd:rif_intervento ?intervento.
  ?discussione rdfs:label ?argomento.
  ?discussione dc:date ?data_intervento.
  
##define the variable 'deputato' (intervenuto) starting from the variable 'intervento'
##ask for name, surname, gender and professional background of the deputy
##define the variable 'intervento' and 'background'
 
  ?intervento ocd:rif_deputato ?deputato.
  ?deputato foaf:firstName ?nome; foaf:surname ?cognome; foaf:gender ?genere.
  OPTIONAL {?deputato dc:description ?background.}
 
  
##define the variable 'gruppo_parlamentare' (passing through 'aderisce') 
  
	?deputato ocd:aderisce ?aderisce.
	?aderisce rdfs:label ?gruppo_parlamentare.
  
##define the variables 'inizioIncarico' and 'fineIncarico', which will be useful to fix a bug

  OPTIONAL{?aderisce ocd:endDate ?fineIncarico.}
  OPTIONAL{?aderisce ocd:startDate ?inizioIncarico.}
  
##specify that I only want deputies who interveined during their mandate  
##(don't take the same deputy more than once only because they changed office/parliamentary group) 
 
  FILTER(?data_intervento >= ?inizioIncarico && ?data_intervento < ?fineIncarico).
}
ORDER BY ?cognome}
  }
LIMIT 10000
OFFSET"

totalgeip17 <- tibble()

#offset to ask for more than  more than 10 000 results 
query_offset <- c("0","5000","10000", "15000", "20000", "25000", "30000", "35000", "40000", 
                  "45000", "50000", "55000", "60000", "65000", "70000", "75000", "80000", "85000",
                  "90000", "100000", "105000")


i <- 0
for (i in 1:length(query_offset)) {
  interventi_deputati <- str_c(query,
               query_offset[i],
               sep = " ")
  #print(query_offset[i])
  final_dataset <- SPARQL(url, interventi_deputati)
  
  totalgeip17 <- rbind(totalgeip17, final_dataset$results)
}
write.csv(totalgeip17, here::here("01_Data.csv/totalgeip17.csv"))




match_donnea <- str_match_all(totalgeip17$argomento, "donn[ea]")
match_donnea

tibbledonnea <- tibble(
  x1=match_donnea,
  x2=totalgeip17$data_intervento,
  x3=totalgeip17$cognome,
  x4=totalgeip17$intervento
)

geip17 <- filter(
  tibbledonnea,
  !match_donnea %in% "character(0)"
)

geip17 <-  unique(geip17)

