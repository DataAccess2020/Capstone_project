##geip17----------

prop.table(table(geip17$genere, geip17$gruppo), margin=1)

barplot <- tibble(
  genere=geip17$genere,
  gruppo= geip17$gruppo
)

count17 <- barplot %>%
  count(genere, gruppo)
count

##tot2015----------

prop.table(table(tot2015$genere, tot2015$donne), margin=1)

boxplot <- tibble(
  genere=tot2015$genere,
  gruppo=tot2015$gruppo,
  donne=tot2015$donne,
  num.gender=tot2015$num.gender
)

count2015 <- boxplot %>%
  count(genere, gruppo, donne, num.gender) 
count2015

count2015f <- filter(
  count2015,
  donne %in% "1"
)

