##geip17 bigrams------
library(forcats)
library(ggplot2)
library(tables)

bigrams_count %>%
  mutate(noswords = fct_reorder(noswords, n)) %>%
  ggplot(aes(x=noswords, y=n)) +
  geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
  coord_flip() +
  xlab("") +
  theme_bw()

##geip17 tables bar chart----------

#generate the data frame for the bar chart, starting from a table with
#gender and parliamentary group. % by column

propt17 <- prop.table(table(geip17$genere, geip17$gruppo_parlamentare), 2)
propt17
propt17 <- as.data.frame(propt17)

propt17 %>%  
  ggplot(aes(x=Var2, y=Freq, fill = factor(Var1))) +
  geom_bar(stat="identity", position = "fill", alpha=.6, width=.4) +
  labs(title = "Gender equality in Italian parliament, XVII legislature",
       subtitle = "How much men and women deputies told about gender equality during the XVII legislature",
       x = "parliamentary group",
       y = "frequency",
       fill="gender") +
       theme_bw()

#in my dataset:161 women, 181 men
#in Italian XVII legislature, 466 deputies were men and 206 were women
#the number of men was 2.26 times higher than the number of women (466/206)
#if men and women had equally told about gender equality and women's rights, in my dataset I should have had 
#a number of men which was 2.26 times higher than the number of women, so I should have had at least 363 men (161x2.26)
#0.78 proportion of women who told about gender equality
#0.39 proportion for men who told about gender equality


##tot2015 bar chart----------

options(scipen = 99) #to avoid esponentials 

#generate a three way table: 1) whether or not the deputy told about women,
#2) if he/she was a man or a women and 3) which was his/her belonging parl. group

trevtable <- xtabs(~argomento+genere+gruppo_parlamentare, data=tot2015)
trevtable

dimnames(trevtable) <- list(argomento = c("any topic", "gender eq/w. rights"),
                            genere = c("women", "men"),
                            gruppo_parlamentare=c("centre", "right", "M5S", "mix", "left"))
trevtable
ftable(trevtable)

#add % so that the sum male+female=100 for both categories of 'argomento'

final_table <- ftable(addmargins(prop.table(trevtable, c(1,3)), 2))*100
final_table

#convert the table into a data frame and take off the raws in which group = sum

percentages <- as_tibble(final_table)
percentages <- filter(
  percentages,
  !gruppo_parlamentare %in% "Sum")

##tot2015-------

##box <- ggplot(percentages, aes(x=argomento, y=Freq, fill=genere)) +
##  geom_boxplot() +
##  facet_wrap(~argomento, scale="free") +
##  theme_bw()
## box

percentages %>%
  ggplot(aes(x=gruppo_parlamentare, y=Freq, fill = factor(genere))) +
  geom_bar(stat="identity", position = "fill", alpha=.6, width=.4) +
  facet_wrap(~argomento, scale="free") +
  labs(title = "Gender equality in Italian parliament, 2015",
       subtitle = "How much men and women deputies told about gender equality in 2015",
       x = "parliamentary group",
       y = "frequency",
       fill="gender") +
  theme_bw() +
  theme(legend.position = "bottom", legend.title.align=0.5)

#chi-squared-------

tab <- (prop.table(table(tot2015$genere, tot2015$argomento), 1))
tab
table(tot2015$genere)

res<- chisq.test(final_table)
res





