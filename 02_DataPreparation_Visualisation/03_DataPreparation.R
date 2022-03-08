##geip17----------
library(tables)

propt17 <- prop.table(table(geip17$genere, geip17$gruppo), 2)

propt17 <- as.data.frame(propt17)


##tot2015----------

boxplot <- tibble(
  genere=tot2015$genere,
  gruppo=tot2015$gruppo,
  donne=tot2015$donne,
  num.gender=tot2015$num.gender
)

group2015 <- tot2015 %>%
  group_by(gruppo, genere) %>%
  count(donne)
group2015

options(scipen = 99)

trevtable <- xtabs(~donne+genere+gruppo, data=tot2015)
trevtable

final_table <- ftable(addmargins(prop.table(trevtable, c(1,3)), 3))*100
final_table


percentages <- as_tibble(final_table)
percentages <- filter(
  percentages,
  !gruppo %in% "Sum")

chisq.test(percentages$genere, percentages$donne, correct = FALSE,
           p = rep(1/length(x), length(x)), rescale.p = FALSE,
           simulate.p.value = TRUE, B = 2000)


