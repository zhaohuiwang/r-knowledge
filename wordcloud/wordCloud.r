#Code for wordcloud creation
#Following info from here: https://www.littlemissdata.com/blog/wordclouds  

#twitter credentials
library(devtools)
install_github("lchiffon/wordcloud2")
install_github("geoffjentry/twitteR")
library(tidyverse)
library(tidytext)
library(stringr)
library(wordcloud2)
library(httpuv)
library(twitteR)
library(rtweet)

token <- create_token(appName, consumerKey, consumerSecret)

keywords <- c("GameOfThrones", "#GoT") 
tweets <- search_tweets(keywords[1], n = 1500, include_rts = FALSE)


setup_twitter_oauth("SNTHUDjY9hzbdg2TE6NralcwU", "vmb76agPs39v2X4OaXZDi0vjWsRtFXLDrRAIadM7fT18sJ0Jlz", "1050749339587489793-i0c03NELo6XvqdL1tlU8GmTkZgeg5t", "HOZ8IL55mhBLBNsSEPpsK1Auml9OIjabgYlBoLxRux9wC")

twits <- searchTwitter("#education", n=150)

twitsText <- lapply(twits, FUN = `[[`, "text") %>% unlist() %>% as_tibble()

#Unnest the words - code via Tidy Text
twitsTable <- twitsText %>% 
  unnest_tokens(word, value)
#remove stop words - aka typically very common words such as "the", "of" etc
data(stop_words)
twitsTableCount <- twitsTable %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE) 
twitsTableCount


#Remove other nonsense words
twitsTableCountFinal <-twitsTableCount %>%
  filter(!word %in% c('https', 'rt', 't.co', 'https', 'gt', '1', '2', '3', '4', '5', '6', '7', '8', '9')) %>% filter(n > 10)
twitsTableCountFinal

wordcloud2(twitsTableCountFinal[1:100,], size=0.7, minSize = 0.1)



#Create Palette
redPalette <- c("#5c1010", "#6f0000", "#560d0d", "#c30101", "#940000")
redPalette

#Download images for plotting
url = "https://raw.githubusercontent.com/lgellis/MiscTutorial/master/twitter_wordcloud/handmaiden.jpeg"
handmaiden <- "handmaiden.jpg"
download.file(url, handmaiden) # download file
url = "https://raw.githubusercontent.com/lgellis/MiscTutorial/master/twitter_wordcloud/resistance.jpeg"
resistance <- "resistance.jpeg"
download.file(url, resistance) # download file

#plots
wordcloud2(hmtTable, size=1.6, figPath = handmaiden, color=rep_len( redPalette, nrow(hmtTable) ) )
wordcloud2(hmtTable, size=1.6, figPath = resistance, color=rep_len( redPalette, nrow(hmtTable) ) )
wordcloud2(hmtTable, size=1.6, figPath = resistance, color="#B20000")

