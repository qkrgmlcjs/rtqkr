if (!require("rvest")) install.packages("rvest")
if (!require("stringi")) install.packages("stringi")
library(stringi)
library(rvest)

melon  <- function(){
  melon  <- readLines("http://www.melon.com/search/trend/index.htm",warn=F)
  Encoding(melon )<-"UTF-8"
  melon  <- unlist(strsplit(melon ,">"))
  melon  <- unique(melon [grep('class="ellipsis"',melon )])
  melon  <- paste0("<",melon )
  melon  <- gsub("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","",melon )
  return(melon )
}
