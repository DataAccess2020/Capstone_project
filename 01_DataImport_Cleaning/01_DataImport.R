install.packages("SPARQL")
library(SPARQL)

data <- SPARQL(url="http://dati.camera.it/sparql", query=## Italian deputies who spoke about gender equality in the 
                                                         ##Chamber of Deputies during the XVII legislature 
                 
                 "SELECT DISTINCT ?argomento ?nome ?cognome ?genere ?dataNascita ?gruppo_parlamentare ?background 
                 ?inizioIncarico ?fineIncarico ?data_intervento ?intervento ?discussione
WHERE { 
##define the variable 'dibattito' and select all those which belong to the XVII legislature. 
##define the variable 'discussione' starting from the variable 'dibattito'
	?dibattito a ocd:dibattito;
                 ocd:rif_leg <http://dati.camera.it/ocd/legislatura.rdf/repubblica_17>;
                 ocd:rif_discussione ?discussione.

##define the variable 'argomento' starting from 'discussione'. Ask for 'data_intervento',
##which will be useful to fix a bug 
##select only discussions which have the word 'donna' or 'donne' in their title
 
  ?discussione ocd:rif_intervento ?intervento;
               rdfs:label ?argomento.
  FILTER(regex(?argomento, 'donn(e|a)', 'i')).
  OPTIONAL{?discussione dc:date ?data_intervento.}
  
##define the variable 'deputato' (intervenuto) starting from the variable 'intervento'
##ask for name, surname, gender and profesional background of the deputy
##define the variable 'intervento' and 'background'
 
  ?intervento ocd:rif_deputato ?deputato.
  ?deputato foaf:firstName ?nome; foaf:surname ?cognome; foaf:gender ?genere.
  ?deputato ocd:rif_ufficioParlamentare ?ufficioparl; rdfs:label ?incarico.
  OPTIONAL {?deputato dc:description ?background.}
 
  
##define the variable 'gruppo_parlamentare' (passing through 'aderisce') 
  
	?deputato ocd:aderisce ?aderisce.
	?aderisce rdfs:label ?gruppo_parlamentare.
  
##define the variables 'inizioIncarico' and 'fineIncarico', which will be useful to fix a bug

  OPTIONAL{?aderisce ocd:endDate ?fineIncarico.}
  OPTIONAL{?aderisce ocd:startDate ?inizioIncarico.}
  
##ask for 'data di nascita', starting from 'persona'
 
  ?persona foaf:surname ?cognome; foaf:firstName ?nome; foaf:gender ?genere.
  ?persona <http://purl.org/vocab/bio/0.1/Birth> ?nascita.
  ?nascita <http://purl.org/vocab/bio/0.1/date> ?dataNascita. 
  
##specify that I only want deputies who interveined during their mandate  
##(don't take the same deputy more than once only because they changed office/parliamentary group) 
 
  FILTER(?data_intervento >= ?inizioIncarico && ?data_intervento < ?fineIncarico).
 
}
ORDER BY ?cognome")

geip17 <- data[["results"]]
View(geip17)



