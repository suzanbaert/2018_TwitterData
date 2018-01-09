library(rtweet)
library(tidyverse)

(trends_avail <- trends_available())
glimpse(trends_avail)

replies <- search_tweets("to:BecomingDataSci 
                         since:2017-12-25",
                         n=500)


replies2 <- search_tweets("to:BecomingDataSci 
                         until:2018-01-03",
                         n=500)


#the origin tweet
#https://twitter.com/BecomingDataSci/status/945366921440002049

replies %>%
  select(created_at, text, screen_name) %>%
  group_by(screen_name) %>%
  summarise(n=n()) %>%
  arrange(desc(n))

replies2 %>%
  group_by(reply_to_status_id) %>%
  summarise(n=n()) %>%
  arrange(desc(n))

replies2 %>%
  arrange(created_at)


replies %>%
  filter(reply_to_status_id == "945366921440002049")%>%
  select(created_at) %>%
  print(n=nrow(.))



#removing replies from BecomingDataSci
actual_replies <- replies %>%
  filter(screen_name != "BecomingDataSci")


tail(replies)
