table(geip17$genere, geip17$gruppo)

barplot <- tibble(
  genere=geip17$genere,
  grparl= geip17$gruppo
)

count <- barplot %>%
  count(genere, grparl)
count