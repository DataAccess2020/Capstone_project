install.packages("SPARQL")
library(SPARQL)

dataset <- SPARQL(url="http://dati.camera.it/sparql", query=#### Italian deputies who spoke about gender equality in the Chamber of Deputies during the XVII legislature 

"SELECT ?deputatoId ?cognome ?nome ?genere ?incarico ?gruppo_parlamentare ?argomento ?data

WHERE {

  ##define the variable 'dibattito' and select all those which belong to the XVII legislature
  
  ?dibattito a ocd:dibattito; ocd:rif_leg <http://dati.camera.it/ocd/legislatura.rdf/repubblica_17>.
  
  ##define the variable 'data' starting from 'dibattito'
  
  ?dibattito ocd:rif_discussione ?discussione.
  ?discussione ocd:rif_seduta ?seduta.
  ?seduta dc:date ?data.
  
  ##define the variable 'argomento della discussione' and select those which contain the words 'donne' or 'donna'
  ?discussione rdfs:label ?argomento.
  FILTER(regex(?argomento,'donn(e|a)','i'))
    
  ##define the variable 'deputato', asking for his/her name, surname, gender, position and belonging parliamentary group
  ?discussione ocd:rif_intervento ?intervento.
  ?intervento ocd:rif_deputato ?deputatoId. 
  ?deputatoId foaf:firstName ?nome; foaf:surname ?cognome; foaf:gender ?genere; ocd:rif_ufficioParlamentare ?ufficioparl. 
  ?ufficioparl rdfs:label ?incarico.
  ?deputatoId ocd:aderisce ?aderisce.
  ?aderisce rdfs:label ?gruppo_parlamentare.
   
} ##sort by date 
ORDER BY ?data")

geip17 <- dataset[["results"]]

