## load packges

if (!require("googlesheets")) {install.packages("googlesheets") }
if (!require("httr")) {install.packages("httr") }
if (!require("lubridate")) {install.packages("lubridate") }
options(stringsAsFactors = F)

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

dataForm <- data.frame(datetime="",source="",rank="",keyword="")

datetime <- as.POSIXlt(now()+9*60*60,tz="KST")
gsname   <- as.Date(datetime)
gsTitle  <- paste0("trtqk_",gsname)

## check and create today's sheet.
workSpace <- try(gs_title(gsTitle))

while(workSpace[1]=="Error in curl::curl_fetch_memory(url, handle = handle) : \n  Timeout was reached\n"){
  
  workSpace <- try(gs_title(gsTitle))
  Sys.sleep(0.1)
  
}

if(class(workSpace)[1]!="googlesheet"){
  if(grep("Error in gs_lookup",workSpace)==1) {
    workSpace <- try(gs_new(title = gsTitle,input=dataForm,row_extent = 73000))
    while(workSpace[1]=="Error in curl::curl_fetch_memory(url, handle = handle) : \n  Timeout was reached\n"){
      workSpace <- try(gs_new(title = gsTitle,input=dataForm,row_extent = 73000))
      Sys.sleep(0.1)
    }
    workSpace <- try(gs_title(gsTitle))
    while(workSpace[1]=="Error in curl::curl_fetch_memory(url, handle = handle) : \n  Timeout was reached\n"){
      workSpace <- try(gs_title(gsTitle))
      Sys.sleep(0.1)
    }
    cont = paste0("새 파일이 생성되었습니다. 공유 설정을 진행해 주세요.")
    report <- try(POST(web_hook,body=list(text=iconv(cont,to="UTF-8")),encode="json"))
    while(report[1]=="Error in curl::curl_fetch_memory(url, handle = handle) : \n  Timeout was reached\n"){
      report <- try(POST(web_hook,body=list(text=iconv(cont,to="UTF-8")),encode="json"))
      Sys.sleep(0.1)
    }
  }
}

## get data

rtData <- rbind(data.frame(datetime = datetime, source= "daum",rank=1:10,keyword=daum()),
                data.frame(datetime = datetime, source= "naver",rank=1:20,keyword=naver()),
                data.frame(datetime = datetime, source= "zum",rank=1:20,keyword=zum()))

# chk_c<-try(gs_read_cellfeed(ss=workSpace))
# 
# while(class(chk_c)[1]!="tbl_df"){
#   chk_c<-try(gs_read_cellfeed(ss=workSpace))
#   Sys.sleep(0.01)
# }
# 
# loc<-chk_c$cell[length(chk_c$cell)]

# rowNum<-as.numeric(substr(loc,2,nchar(loc)))+1
rowNum<-hour(datetime)*50*60 + minute(datetime)*50 + 2
chk_e<-try(gs_edit_cells(ss=workSpace,input = rtData,
                  col_names = F,anchor = paste0("A",rowNum)))

while(class(chk_e)[1]!="googlesheet"){
  chk_e<-try(gs_edit_cells(ss=workSpace,input = rtData,
                           col_names = F,anchor = paste0("A",rowNum)))
  Sys.sleep(0.01)
}

rm(rtData)

# web_hook = "https://hooks.slack.com/services/XXXXXXXXXXXXXXXXXXXX"
# save(web_hook,file="web_hook.RData")
load("/home/rstudio/realtimeQueryKeywordKr/web_hook.RData")

cont = paste0(datetime,"의 업로드가 완료되었습니다.")
report <- try(POST(web_hook,body=list(text=iconv(cont,to="UTF-8")),encode="json"))
while(report[1]=="Error in curl::curl_fetch_memory(url, handle = handle) : \n  Timeout was reached\n"){
  report <- try(POST(web_hook,body=list(text=iconv(cont,to="UTF-8")),encode="json"))
  Sys.sleep(0.3)
}

