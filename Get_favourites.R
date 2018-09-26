library(rtweet)
library(tidyverse)
library(tidytext)

my_likes <- get_favorites("suzanbaert", n=3000)

glimpse(my_likes)

texts <- my_likes$text


index <- str_detect(texts, pattern = ".+slides.+")
texts[index]

