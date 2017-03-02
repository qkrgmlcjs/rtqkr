if (!require("lubridate")) install.packages("lubridate")
library(lubridate)

gs_new(title = paste0("rtqk_",today()),verbose = T)
gs_ls()
ss = gs_title("rtqk_2017-02-28")
dat <- data.frame("tt",1:1000000)
gs_add_row(ss = ss, input = dat,verbose = T)
