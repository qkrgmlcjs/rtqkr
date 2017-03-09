## load packges

if (!require("googlesheets")) {install.packages("googlesheets") }
if (!require("httr")) {install.packages("httr") }
if (!require("lubridate")) {install.packages("lubridate") }


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
workSpace <- try(gs_title(paste0("rtqk_",today())))

while(workSpace[1]=="Error in curl::curl_fetch_memory(url, handle = handle) : \n  Timeout was reached\n"){
  
  workSpace <- try(gs_title(paste0("rtqk_",today())))
  Sys.sleep(0.3)
  
}

if(class(workSpace)[1]!="googlesheet"){
  if(grep("Error in gs_lookup",workSpace)==1) {
    gs_new(title = paste0("rtqk_",today()),input=dataForm)
    workSpace <- try(gs_title(paste0("rtqk_", today())))
  }
}

## get data
datetime <- now()

rtData <- rbind(data.frame(datetime = datetime, source= "daum",rank=1:10,keyword=daum()),
                data.frame(datetime = datetime, source= "naver",rank=1:20,keyword=naver()),
                data.frame(datetime = datetime, source= "zum",rank=1:20,keyword=zum()))

for (i in 1:nrow(rtData)) {
  workSpace <- gs_add_row(ss=workSpace, input = (rtData[i,]))
  Sys.sleep(0.3)
}

rm(rtData)

# web_hook = "https://hooks.slack.com/services/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"
# save(web_hook,file="web_hook.RData")
load("/home/rstudio/realtimeQueryKeywordKr/web_hook.RData")

if(i==50){
  cont = paste0(datetime,"의 데이터 업로드가 완료되었습니다.")
  POST(web_hook,body=list(text=iconv(cont,to="UTF-8")),encode="json")
}

