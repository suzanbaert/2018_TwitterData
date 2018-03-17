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

saveRDS(sideproject, "sideproject.RDS")



# -------
# visualizing
# -------
ts_plot(sideproject) +
  labs(title = "Side project tweets", y="number of tweets")



# -------
# text analysis
# -------



