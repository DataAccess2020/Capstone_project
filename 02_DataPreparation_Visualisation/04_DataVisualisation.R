library(forcats)

bigrams_count %>%
  mutate(noswords = fct_reorder(noswords, n)) %>%
  ggplot(aes(x=noswords, y=n)) +
  geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
  coord_flip() +
  xlab("") +
  theme_bw()