library(rtweet)
library(tidyverse)
library(tidytext)

## original tweet
## https://twitter.com/aprilwensel/status/973287711736868865


# -------
# getting the tweets
# -------

sideproject <- search_tweets(q = "#MySideProject ", include_rts = FALSE, n=500)

replies_aprilwensel <- search_tweets("to:aprilwensel since:2018-03-12", n=1000)
replies_sideproject <- subset(replies_aprilwensel, reply_to_status_id == "973287711736868865") 


#union does not work because some columns are lists, so just checking that the columns are the same
identical(colnames(sideproject), colnames(replies_sideproject))

#then merging and removing duplicates
sideproject <- rbind(sideproject, replies_sideproject)
sideproject <- sideproject[!duplicated(sideproject), ]

saveRDS(sideproject, "data/sideproject.RDS")

sideproject <- readRDS("data/sideproject.RDS")


# -------
# visualizing
# -------

ts_plot(sideproject) +
  labs(title = "Side project tweets", y="number of tweets")





# -------
# text analysis
# -------


Encoding(sideproject$text) <- "UTF-8"
sideproject$text <- iconv(sideproject$text, from="windows-1252", to="UTF-8")


regex_remove <- "(@\\S+)|(#?[Mm]y[Ss]ide[Pp]roject)|(side projects?)|(http\\S+)|(&amp)"


sideproject %>% 
  select(status_id, text) %>% 
  mutate(text = str_replace_all(text, regex_remove, ""),
         text = str_replace_all(text, "bake", "baking"),
         text = str_replace_all(text, "knit[^t]", "knitting"),
         text = str_replace_all(text, "sew[^i]", "sewing"),
         text = str_replace_all(text, "crochet[^i]", "crocheting"),
         text = str_replace_all(text, "bike", "biking"),
         text = str_replace_all(text, "hike", "hiking")) %>% 
  unnest_tokens(word, text) %>% 
  filter(!word %in% stop_words$word) %>% 
  count(word, sort=TRUE) %>% 
  print(n=30)


str_view(sideproject$text, "rochet[^i]", match=TRUE)

#still something wrong. crotchet for instance is given 8 times, but shows as  times...