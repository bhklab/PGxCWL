
getTissueCuration <- function(verbose=FALSE){
options(stringsAsFactors=FALSE)
cell_all = commandArgs(trailingOnly=TRUE)[1]
load(commandArgs(trailingOnly=TRUE)[2])  
cell_all <- read.csv(file = cell_all, na.strings=c("", " ", "NA"))
curationTissue <- cell_all[which(!(is.na(cell_all[ , "Ben_Neel.cellid"]) & is.na(cell_all[,"Cescon.cellid"]))),]
curationTissue <- curationTissue[ , c("unique.tissueid", "Ben_Neel.tissueid", "Cescon.cellid")]

rownames(curationTissue) <- curationCell[ , "unique.cellid"]

save(curationTissue, cell_all, file="tissue_cur.RData")

return(curationTissue)
return(cell_all)

}

getTissueCuration(verbose = FALSE)