##geip17------
library(forcats)
library(ggplot2)
library(dplyr)


bigrams_count %>%
  mutate(noswords = fct_reorder(noswords, n)) %>%
  ggplot(aes(x=noswords, y=n)) +
  geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
  coord_flip() +
  xlab("") +
  theme_bw()

propt17 %>%  
  mutate(Var2 = fct_reorder(Var2, Freq)) %>%
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

##tot2015-------

box <- ggplot(percentages, aes(x=donne, y=Freq, fill=genere)) +
  geom_boxplot() +
  facet_wrap(~donne, scale="free") +
  theme_bw()
box

percentages %>%
  mutate(gruppo = fct_reorder(gruppo, Freq)) %>%
  ggplot(aes(x=gruppo, y=Freq, fill = factor(genere))) +
  geom_bar(stat="identity", position = "fill", alpha=.6, width=.4) +
  facet_wrap(~donne, scale="free") +
  labs(title = "Gender equality in Italian parliament, 2015",
       subtitle = "How much men and women deputies told about gender equality in 2015",
       x = "parliamentary group",
       y = "frequency",
       fill="gender") +
  theme_bw() +
  theme(legend.position = "bottom", legend.title.align=0.5)

