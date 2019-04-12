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
      
      
      sensitivity.info <- raw.sensitivity[ , c(1,2, 3, grep(tt, colnames(raw.sensitivity)))]
      colnames(sensitivity.info) <- c("cellid", "drugid", "min.Dose.uM", "max.Dose.uM")
      sensitivity.info <- cbind(sensitivity.info, "nbr.conc.tested"=con_tested)
      
      x <- matchToIDTableCELL(sensitivity.info[, "cellid"], curationCell, "GRAY.cellid")
      x <- as.character(x)
      sensitivity.info[, "cellid"] <- x
      
      
      sensitivity.info[,"drugid"] <- gsub("\\s*\\([^\\)]+\\)","",sensitivity.info[,"drugid"]) #REMOVES PARATHESES JUST FOR MATCHING
      x2 <- matchToIDTableDRUG(sensitivity.info[, "drugid"], curationDrug, "GRAY.drugid")
      x2 <- as.character(x2)
      sensitivity.info[, "drugid"] <- x2
      
      raw.sensitivity <- raw.sensitivity[ ,-c(1,2)]
      raw.sensitivity <- array(c(as.matrix(raw.sensitivity[ ,1:con_tested]), as.matrix(raw.sensitivity[ ,(con_tested+1):(2*con_tested)])), c(nrow(raw.sensitivity), con_tested, 2),
                               dimnames=list(rownames(raw.sensitivity), colnames(raw.sensitivity[ ,1:con_tested]), c("Dose", "Viability")))
      
      
      load(commandArgs(trailingOnly=TRUE)[6])
      load(commandArgs(trailingOnly=TRUE)[7])
    
      profilecol <- gsub("\\s*\\([^\\)]+\\)","",as.character(colnames(profiles)[indices]))
      drug <- matchToIDTableDRUG(profilecol, curationDrug, "GRAY.drugid")
      drug <- as.character(drug)
      drug <- rep(drug, times=70)
      #drug <- as.character(unique(unlist(y)))
      
      
      cell <- matchToIDTableCELL(rownames(profiles), curationCell, "GRAY.cellid")
      cell <- as.character(cell)
      cell <- rep(cell, each=90)
      
      GI50initial <- data.frame("cellid"=cell, "drugid"=drug, "GI50_published"=GI50)
      GI50match <- data.frame("cellid"=sensitivity.info[,"cellid"], "drugid"=sensitivity.info[,"drugid"], "GI50"=NA)
      
      GI50match$GI50 <- GI50initial[match(paste(GI50match$cellid,GI50match$drugid),paste(GI50initial$cellid,GI50initial$drugid)),"GI50_published"]
      
      sensitivity.profiles <- matrix(NA, dimnames = list(rownames(sensitivity.info), "GI50_published"), nrow=nrow(sensitivity.info))
      sensitivity.profiles[,"GI50_published"] <- GI50match$GI50
      
      sensitivity.profiles <- cbind(sensitivity.profiles, "auc_recomputed"=recomputed$AUC, "ic50_recomputed"=recomputed$IC50)
      
      slope <- NULL
      for(exp in rownames(sensitivity.info)){
        slope <- c(slope, computeSlope(raw.sensitivity[exp, , "Dose"], raw.sensitivity[exp, , "Viability"])) #computeSlope (returns normalized slope of drug response curve)
      }
      
      names(slope) <- rownames(sensitivity.info)
      sensitivity.profiles <- cbind(sensitivity.profiles, "slope_recomputed"=slope)
      head(sensitivity.profiles)
      
      s <- unique(sensitivity.info[,"drugid"])
      curationDrug <- curationDrug[s, ]
      druginfo <- data.frame("drugid"=curationDrug$unique.drugid)
      rownames(druginfo) <- druginfo$drugid
      
    
      print("finished sensitivity")
    
    #RNA-seq Processed Data
    
    load(commandArgs(trailingOnly=TRUE)[8])
    
    print("finished RNASeq")
    
    #RPPA Processed Data
    
    load(commandArgs(trailingOnly=TRUE)[9])
    
    print("finished RPPA")
    
    #RNA U133A Array & Exon Array Processed Data
    
    load(commandArgs(trailingOnly=TRUE)[10])
    
    print("finished RNA")
    
    #SNP Processed Data
    
    load(commandArgs(trailingOnly=TRUE)[11])
    
    print("finished SNP")
    
    #methylation processed data
    
    load(commandArgs(trailingOnly=TRUE)[12])
    
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
    
    GRAY2013 <- PharmacoSet(molecularProfiles=z,
                        
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
    save(GRAY2013,file="GRAY_2013.RData")
    
    
    return (GRAY2013)
    
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






