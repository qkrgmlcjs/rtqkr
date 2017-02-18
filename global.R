if (!require("rvest")) install.packages("rvest")
if (!require("stringi")) install.packages("stringi")
if (!require("googlesheets")) install.packages("googlesheets")
if (!require("dplyr")) install.packages("dplyr")
library(stringi)
library(rvest)
library(googlesheets)
suppressMessages(library(dplyr))
my_sheets <- gs_ls()
my_sheets

gs_delete(tem)

if(TRUE){
  tem <- gs_new("realtimeQueryKeywordKr", ws_title = "dat_20170218",trim = TRUE, 
                verbose = FALSE)
}

10+2*20

zum <- function(){
  zum <- readLines("http://zum.com",warn=F)
  Encoding(zum)<-"UTF-8"
  zum <- unique(zum[grep("keyword d_keyword",zum)])
  zum <- gsub("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","",zum)
  return(zum)
}
daum <-function(){
  daum <- readLines("http://www.daum.net",warn=F)
  Encoding(daum)<-"UTF-8"
  daum <- unique(daum[grep("ellipsis_g",daum)+1])
  daum <- daum[5:14]
  daum <- gsub("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","",daum)
  return(daum)
}

naver <- function(){
  naver <- readLines("http://www.naver.com",warn=F)
  Encoding(naver)<-"UTF-8"
  naver <- unlist(strsplit(naver,"<"))
  naver <- unique(naver[grep('class="ell"',naver)])
  naver <- paste0("<",naver)
  naver <- gsub("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","",naver)
  return(naver)
}

