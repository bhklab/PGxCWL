
getCellCuration <- function(verbose=FALSE){
options(stringsAsFactors=FALSE)
cell_all = commandArgs(trailingOnly=TRUE)[1]  
cell_all <- read.csv(file = cell_all, na.strings=c("", " ", "NA"))
curationCell <- cell_all[which(!(is.na(cell_all[ , "Ben_Neel.cellid"]) & is.na(cell_all[,"Cescon.cellid"]))),]
curationCell <- curationCell[ , c("unique.cellid", "Ben_Neel.cellid", "Cescon.cellid")]
rownames(curationCell) <- curationCell[ , "unique.cellid"]

save(curationCell, file="cell_cur.RData")

return(curationCell)



}

getCellCuration(verbose = FALSE)