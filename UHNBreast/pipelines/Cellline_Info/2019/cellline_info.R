library(readxl)
library(openxlsx)
library(CoreGx)


getCelllineInfo <- function(verbose=FALSE){
  
options(stringsAsFactors=FALSE)
badchars <- "[\xb5]|[]|[ ,]|[;]|[:]|[-]|[+]|[*]|[%]|[$]|[#]|[{]|[}]|[[]|[]]|[|]|[\\^]|[/]|[\\]|[.]|[_]|[ ]"
load(commandArgs(trailingOnly=TRUE)[2])
print(head(curationCell))
cellline_info = commandArgs(trailingOnly=TRUE)[1]


#match to Cell Curation

matchToIDTableCELL <- function(ids,tbl, column) {
  sapply(ids, function(x) {
    myx <- grep(paste0("((///)|^)",x,"((///)|$)"), tbl[,column])
    if(length(myx) > 1){
      stop("Something went wrong in curating cell ids")
    }
    return(tbl[myx, "unique.cellid"])
  })
}
    cellineinfo <- read.csv(file=cellline_info, na.strings=c("", " ", "NA"))
    cellineinfo$tissueid <- "breast"
    cellineinfo$cellid <- matchToIDTableCELL(cellineinfo$cellid, curationCell, "Ben_Neel.cellid")
    dupCell <- cellineinfo$cellid[duplicated(cellineinfo$cellid)]
    for (cell in dupCell){
      myx <- which(cellineinfo$cellid == cell)
      cellineinfo[myx[1],] <- apply(cellineinfo[myx,], 2, function(x){
        return(unique(na.omit(x)))
      })
      cellineinfo <- cellineinfo[-myx[2],]
    }
    rownames(cellineinfo) <- cellineinfo$cellid
    
    cellineinfo["HCT-116","tissueid"] <- "large_intestine"
    cellineinfo["DU-145","tissueid"] <- "prostate"
    cellineinfo[84,"cellid"] <- "HCT-116"
    cellineinfo[85,"cellid"] <- "DU-145"


save(cellineinfo, file="cellline_info.RData")

return(cellineinfo)


}

getCelllineInfo(verbose = FALSE)