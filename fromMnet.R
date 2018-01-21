if (!require("rvest")) install.packages("rvest")
if (!require("stringi")) install.packages("stringi")
library(stringi)
library(rvest)




mnet  <- function(){
  mnet <- readLines("http://code.mnet.com/search/l_inc/daily.asp",warn=F)
  Encoding(mnet)<-"UTF-8"
  mnet <- unique(mnet[grep('"keyword":"',mnet)])
  mnet <- mnet[1:10]
  mnet <- gsub("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","",mnet)
  return(mnet)
}
