##text mining---------

#remove numbers from the variable 'argomento'

geip17$argomento <- removeNumbers(geip17$argomento)

#donwload a list of italian stopwords

italiansw <- tm::stopwords("italian")
stop_words
stopwords

##list words I don't want to include in the analysis 

manual_swords <-  c("d", "n", "s", "nonch")
comb_mswords <- c(manual_swords, italiansw)
comb_mswords

##create a data frame with all the words I don't want to include

manualswords <- tibble(
  x1=comb_mswords
)
manualswords

##split the variable 'argomento' into its single 'units of text' ('tokens'), in this case words

?unnest_tokens()

bigrams <- geip17 %>% 
  select(argomento, genere) %>% 
  unnest_tokens(split_argomento, argomento, token="ngrams", n=2)

##split the column 'split_argomento' into its single words

bigrams_sep <- bigrams %>% 
  separate(split_argomento, c("parola1", "parola2"), sep = " ")

##remove stop words, and other words I don't want to include

filterbigr <- bigrams_sep %>% 
  filter(!parola1 %in% manualswords$x1) %>% 
  filter(!parola2 %in% manualswords$x1)

##recombine the columns 'parola1' and 'parola2' into one 

bigramsunited <- filterbigr %>%
  unite(noswords, parola1, parola2, sep = " ")
bigramsunited

##filter bigramsunited to obtain a dataframe where only the pattern "donn[ea]" appears 
##in the column 'split_argomento' 

greplbu <- bigramsunited %>% 
  filter(grepl(pattern="donn[ea]", noswords, ignore.case = TRUE))

##count the most common bigrams

bigrams_count <- greplbu %>%
  count(noswords)
bigrams_count

####------------

##check what the string 'donne audizione' means

Audizione <- str_which(geip17$argomento, "Audizione")

length(Audizione)

set.seed(1)
sample <- sample(Audizione, 40)
sample

i <- 0
for (i in 1:length(sample)) {
  cat((geip17$argomento)[i], sep="")
}


