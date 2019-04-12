getGRAYP <-
  function (
    verbose=FALSE,
    nthread=1){
    options(stringsAsFactors=FALSE)
    badchars <- "[\xb5]|[]|[ ,]|[;]|[:]|[-]|[+]|[*]|[%]|[$]|[#]|[{]|[}]|[[]|[]]|[|]|[\\^]|[/]|[\\]|[.]|[_]|[ ]"
    z <- list()
    
    
    load(commandArgs(trailingOnly=TRUE)[1])
    load(commandArgs(trailingOnly=TRUE)[2])
    load(commandArgs(trailingOnly=TRUE)[3])
    
    #match to cell curation
    
    matchToIDTableCELL <- function(ids,tbl, column) {
      sapply(ids, function(x) {
        myx <- grep(paste0("((///)|^)",x,"((///)|$)"), tbl[,column])
        if(length(myx) > 1){
          stop("Something went wrong in curating cell ids")
        }
        return(tbl[myx, "unique.cellid"])
      })
    }
    
    
    #match to drug curation 
    
    matchToIDTableDRUG <- function(ids,tbl, column) {
      sapply(ids,function(x) {
        myx <- grep(paste0("((///)|^)",x,"((///)|$)"), tbl[,column])
        if(length(myx) > 1){
          stop("Something went wrong in curating drug ids")
        }
        return(tbl[myx, "unique.drugid"])
      })
    }
    
    
    
    ## cell information
    
    load(commandArgs(trailingOnly=TRUE)[4])

    
    
    
    ########################
    ####Drug Sensitivity####
    ########################
    
    print("starting sensitivity")
      
    load(commandArgs(trailingOnly=TRUE)[5])
    load(commandArgs(trailingOnly=TRUE)[6])
    
    dd <- which(duplicated(gray.GRvalues))
    gray.GRvalues <- gray.GRvalues[-dd,]
    gray.GRvalues <- gray.GRvalues[-which(gray.GRvalues[, "Small.Molecule.HMS.LINCS.ID.1"]==""),]
    
    sensitivity.profiles <- cbind("auc_recomputed"=recomputed$AUC/100, "ic50_recomputed"=recomputed$IC50)
    rownames(sensitivity.profiles) <- rownames(raw.sensitivity)
    
    dim(sensitivity.info)
    
    remove.items <- which(sensitivity.info[,"cellid"] %in% cells.cross.reference[which(cells.cross.reference$COMMENT == "REMOVE"), "HEISER.NAME"])
    sensitivity.info <- sensitivity.info[-remove.items,]
    sensitivity.profiles <- sensitivity.profiles[-remove.items,]
    raw.sensitivity <- raw.sensitivity[-remove.items,,]
    sensitivity.info[, "cellid"] <- cells.cross.reference$LINCS.NAME[match( sensitivity.info[, "cellid"], cells.cross.reference[ , "HEISER.NAME"])]
    
    ##check
    dim(sensitivity.info)
    length(intersect(unique(gray.GRvalues[, "Cell.Name"]), unique(sensitivity.info[, "cellid"])))
    length(setdiff(unique(gray.GRvalues[, "Cell.Name"]), unique(sensitivity.info[, "cellid"])))
    length(setdiff(unique(sensitivity.info[, "cellid"]), unique(gray.GRvalues[, "Cell.Name"])))
    
    remove.items.dd <- which(sensitivity.info[,"drugid"] %in% drugs.cross.reference[which(drugs.cross.reference$COMMENT == "REMOVE"), "HEISER.NAME"])
    sensitivity.info <- sensitivity.info[-remove.items.dd,]
    sensitivity.profiles <- sensitivity.profiles[-remove.items.dd,]
    raw.sensitivity <- raw.sensitivity[-remove.items.dd,,]
    sensitivity.info[, "drugid"] <- drugs.cross.reference$HEISER.NAME[match(sensitivity.info[, "drugid"], drugs.cross.reference[ , "HEISER.NAME"])]
    
    ##check
    dim(sensitivity.info)
    length(intersect(unique(gray.GRvalues[, "Small.Molecule.HMS.LINCS.ID"]), unique(sensitivity.info[, "drugid"])))
    length(setdiff(unique(gray.GRvalues[, "Small.Molecule.HMS.LINCS.ID"]), unique(sensitivity.info[, "drugid"])))
    ###two compounds in gray.GRvalues have not been in cross reference file "10110-101-1", "10252-101-1"
    length(setdiff(unique(sensitivity.info[, "drugid"]), unique(gray.GRvalues[, "Small.Molecule.HMS.LINCS.ID"])))
    
    #Add New SUM190PT Cell line & Tissue
    
    #curationCell <- rbind(curationCell, c("SUM190PT","SUM190PT")) 
    #rownames(curationCell)[85] <- "SUM190PT"
    
    #curationTissue <- rbind(curationTissue, c("breast","breast")) 
    #rownames(curationTissue)[85] <- "SUM190PT"
    
    #cellineinfo <- rbind(cellineinfo, c("SUM190PT", "breast", "NA", "NA", "NA","NA","NA","NA","NA","NA","NA" ))
    #rownames(cellineinfo)[85] <- "SUM190PT"
    
    sensitivity.info[,"cellid"] <- gsub("-", "", sensitivity.info[,"cellid"])
    sensitivity.info[,"cellid"] <- gsub(" ", "", sensitivity.info[,"cellid"])
    sensitivity.info[,"cellid"] <- toupper(sensitivity.info[,"cellid"])
    x2 <- matchToIDTableCELL(sensitivity.info[,"cellid"], curationCell, "GRAY.cellid")
    x2 <- as.character(x2)
    sensitivity.info[, "cellid"] <- x2
    
    sensitivity.info[,"drugid"] <- gsub("\\s*\\([^\\)]+\\)","",sensitivity.info[,"drugid"])
    
    
    
    x <- matchToIDTableDRUG(sensitivity.info[, "drugid"], curationDrug, "GRAY.drugid")
    
    
    
    #i <- sapply(x, is.factor)
    #x[i] <- lapply(x[i], as.character)
    #sensitivity.info[, "drugid"] <- rownames(curationDrug)[match(sensitivity.info[, "drugid"], curationDrug[ , "GRAY.drugid"])]
    
    y <- as.character(x)
    sensitivity.info[, "drugid"] <- y
    
    replicates <- unique(paste(gray.GRvalues[, "Cell.Name"], gray.GRvalues[, "Small.Molecule.HMS.LINCS.ID"], sep="_"))
    replicates.ll <-NULL
    i=1
    for(replicate in replicates){
      i=i+1
      cell <- strsplit(replicate, "_")[[1]][1]
      drug <- strsplit(replicate, "_")[[1]][2]
      xx <- which(gray.GRvalues[, "Cell.Name"] == cell& gray.GRvalues[, "Small.Molecule.HMS.LINCS.ID"]==drug)
      yy <- which(sensitivity.info[,"cellid"] == cell & sensitivity.info[,"drugid"]==drug)
      if(length(xx) > 5){
        #browser()
        #print(length(xx))
        if(length(xx) == length(yy)){
          replicates.ll <- c(replicates.ll, length(xx))
        }
      }
    }
    
    druginfo <- data.frame("drugid"=curationDrug$unique.drugid)
    rownames(druginfo) <- druginfo$drugid
    
    #Add missing 2013 sensitivity raw and sensitivity info
    
    
    setdiff(gray2013sens$info$drugid, as.character(sensitivity.info[,"drugid"]))
    setdiff(gray2013sens$info$cellid, as.character(sensitivity.info[,"cellid"]))
    missing <- setdiff(gray2013sens$info$drugid, as.character(sensitivity.info[,"drugid"]))
    missinginfo <- gray2013sens$info[gray2013sens$info$drugid %in% missing,]
    missingrows <- rownames(gray2013sens$info)[gray2013sens$info$drugid %in% missing]
    missingrawdose <- gray2013sens$raw[,,"Dose"][rownames(gray2013sens$raw[,,"Dose"]) %in% missingrows,]
    missingrawviability <- gray2013sens$raw[,,"Viability"][rownames(gray2013sens$raw[,,"Viability"]) %in% missingrows,]
    r1 <- rbind(raw.sensitivity[,,"Dose"], missingrawdose)
    r2 <- rbind(raw.sensitivity[,,"Viability"], missingrawviability)
    newraw <- array(c(r1, r2), c(10897, 9, 2), dimnames=list(rownames(r1), colnames(r1), c("Dose", "Viability")))
    
    sensitivity.info <- rbind(sensitivity.info, missinginfo)
    raw.sensitivity <- newraw
    
    # #Add previous recomputed GI50, AUC, IC50 data to new GRAY data  
    
    ff <- gray2013sens$profiles[rownames(gray2013sens$profiles) %in% missingrows,]
    GI_Match <- match(rownames(gray2013sens$profiles), rownames(sensitivity.profiles))
    GI_Match <- unique(GI_Match)
    GIvalues <- gray2013sens$profiles$GI50_published[match(rownames(sensitivity.profiles), rownames(gray2013sens$profiles))]
    sensitivity.profiles <- cbind(sensitivity.profiles, "GI50_published" = GIvalues)
    slope_Match <- match(rownames(gray2013sens$profiles), rownames(sensitivity.profiles))
    slope_Match <- unique(slope_Match)
    slopevalues <- gray2013sens$profiles$slope_recomputed[match(rownames(sensitivity.profiles), rownames(gray2013sens$profiles))]
    sensitivity.profiles <- cbind(sensitivity.profiles, "slope_recomputed" = slopevalues)
    rownames(sensitivity.profiles[is.na(sensitivity.profiles[,"auc_recomputed"]),])
    AUCvalues <- gray2013sens$profiles$auc_recomputed[match(rownames(sensitivity.profiles[is.na(sensitivity.profiles[,"auc_recomputed"]),]), rownames(gray2013sens$profiles))]
    #AUCvalues <- formatC(AUCvalues, format = "e", digits = 6)
    sensitivity.profiles[is.na(sensitivity.profiles[,"auc_recomputed"]),][,"auc_recomputed"] <- AUCvalues
    rownames(sensitivity.profiles[is.na(sensitivity.profiles[,"ic50_recomputed"]),])
    ic50values <- gray2013sens$profiles$ic50_recomputed[match(rownames(sensitivity.profiles[is.na(sensitivity.profiles[,"ic50_recomputed"]),]), rownames(gray2013sens$profiles))]
    #ic50values <- formatC(ic50values, format = "e", digits = 6)
    sensitivity.profiles[is.na(sensitivity.profiles[,"ic50_recomputed"]),][,"ic50_recomputed"] <- ic50values
    sensitivity.profiles <- rbind(sensitivity.profiles,ff)
      
    
    print("finished sensitivity")
    
    #RNA-seq Processed Data
    
    load(commandArgs(trailingOnly=TRUE)[7])
    
    print("finished RNASeq")
    
    #RPPA Processed Data
    
    load(commandArgs(trailingOnly=TRUE)[8])
    
    print("finished RPPA")
    
    #RNA U133A Array & Exon Array Processed Data
    
    load(commandArgs(trailingOnly=TRUE)[9])
    
    print("finished RNA")
    
    #SNP Processed Data
    
    load(commandArgs(trailingOnly=TRUE)[10])
    
    print("finished SNP")
    
    #methylation processed data
    
    load(commandArgs(trailingOnly=TRUE)[11])
    
    print("finished methylation")
    
    z <- c(z,c(
      "rnaseq.exp.matrix"=RNA_exp_matrix_processed,
      "rnaseq.exp"=RNA_exp_processed,
      "rnaseq.counts"=RNA_counts_processed,
      "rppa"=RPPA_processed,
      "cnv"=CNV_processed,
      "rna.exon"=Exon_processed,
      "rna.u133a"=U133A_processed,
      "methylation"=Methylation_processed)
    )
    
    GRAY2017 <- PharmacoSet(molecularProfiles=z,
                        
                        name="GRAY", 
                        cell=cellineinfo, 
                        drug=druginfo, 
                        sensitivityInfo=sensitivity.info, 
                        sensitivityRaw=raw.sensitivity, 
                        sensitivityProfiles=sensitivity.profiles, 
                        sensitivityN=NULL,
                        curationCell=curationCell, 
                        curationDrug=curationDrug, 
                        curationTissue=curationTissue, 
                        datasetType="sensitivity")
    save(GRAY2017,file="GRAY_2017.RData")
    
    
    return (GRAY2017)
    
  }



library(PharmacoGxPrivate)
library(PharmacoGx)
library(readr)
library(tximport)
library(rhdf5)
library(gdata)
library(readxl)
library(openxlsx)
library(CoreGx)




getGRAYP(verbose=FALSE,
         nthread=1)






