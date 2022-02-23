
library(rtweet)
trends <- rtweet::get_trends(woeid = 23424768)

rtweet::post_tweet(
  "Estou tuitando no curso de Web Scraping da @curso_r, usando o pacote {rtweet}! #rstats"
)


da_timeline <- rtweet::get_timeline("azeloc")

da_mencoes <- rtweet::get_mentions()

usuarios_r <- rtweet::search_users("#rstats", 100)
