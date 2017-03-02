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


