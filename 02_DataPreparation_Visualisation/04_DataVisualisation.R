library(forcats)

bigrams_count %>%
  mutate(noswords = fct_reorder(noswords, n)) %>%
  ggplot(aes(x=noswords, y=n)) +
  geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
  coord_flip() +
  xlab("") +
  theme_bw()

count %>%
  mutate(grparl = fct_reorder(grparl, n)) %>%
  ggplot(aes(x=grparl, y=n, fill = factor(genere))) +
  geom_bar(stat="identity", position = "dodge", alpha=.6, width=.4) +
  coord_flip() +
  xlab("") +
  theme_bw()

#in my dataset:161 women, 181 men
#in Italian XVII legislature, 466 deputies were men and 206 were women
#the number of men was 2.26 times higher than the number of women (466/206)
#if men and women had equally told about gender equality and women's rights, in my dataset I should have had 
#a number of men which was 2.26 times higher than the number of women, so I should have had at least 363 men (161x2.26)
#0.78 proportion of women who told about gender equality
#0.39 proportion for men who told about gender equality

