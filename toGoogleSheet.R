#!/usr/bin/env Rscript
## load packges
if (!require("googlesheets")) {install.packages("googlesheets") }
if (!require("lubridate")) {install.packages("lubridate") }
if (!require("devtools")) {install.packages("devtools")}
if (!require("slackr")) {devtools::install_github("mrchypark/slackr")}
if (!require("xml2")) {install.packages("xml2") }
if (!require("rvest")) {install.packages("rvest")}

## load get data func

zum <- function(){
  zum <- readLines("http://zum.com",warn=F)
  Encoding(zum)<-"UTF-8"
  zum <- unique(zum[grep("keyword d_keyword",zum)])
  zum <- gsub("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","",zum)
  return(zum)
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

daum <-function(){
  daum <- readLines("http://www.daum.net",warn=F)
  Encoding(daum)<-"UTF-8"
  daum <- unique(daum[grep("ellipsis_g",daum)+1])
  daum <- daum[5:14]
  daum <- gsub("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","",daum)
  return(daum)
}

dataForm <- data.frame(datetime=NA,source=NA,rank=NA,keyword=NA)
# dataForm <- dataForm[-1,]

## check and create today's sheet.
workSpace <- try(gs_title(paste0("rtqk_",today())),silent = T)
if(class(workSpace)[1]=="try-error") {
  gs_new(title = paste0("rtqk_",today()),input=dataForm)
  workSpace <- try(gs_title(paste0("rtqk_", today())),silent = T)
}

## get data
datetime <- now()

rtData <- rbind(data.frame(datetime = datetime, source= "daum",rank=1:10,keyword=daum(),stringsAsFactors = F),
                data.frame(datetime = datetime, source= "naver",rank=1:20,keyword=naver(),stringsAsFactors = F),
                data.frame(datetime = datetime, source= "zum",rank=1:20,keyword=zum(),stringsAsFactors = F))

for (i in 1:nrow(rtData)) {
  workSpace <- gs_add_row(ss=workSpace, input = (rtData[i,]))
  Sys.sleep(0.3)
}
rm(rtData)

## reference https://dyerlab.ces.vcu.edu/2016/07/08/collab-slack-r/

slackr_setup()
slackr_bot("data is up.")

