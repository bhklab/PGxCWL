getUHN <-
  function (#gene=TRUE,
    verbose = FALSE,
    nthread = 1) {
    
    options(stringsAsFactors=FALSE)
    z <- list()
    badchars <- "[\xb5]|[]|[ ,]|[;]|[:]|[-]|[+]|[*]|[%]|[$]|[#]|[{]|[}]|[[]|[]]|[|]|[\\^]|[/]|[\\]|[.]|[_]|[ ]"
    
    #match to CurationCell
    
    matchToIDTableCELL <- function(ids,tbl, column) {
      sapply(ids, function(x) {
        myx <- grep(paste0("((///)|^)",x,"((///)|$)"), tbl[,column])
        if(length(myx) > 1){
          stop("Something went wrong in curating cell ids")
        }
        return(tbl[myx, "unique.cellid"])
      })
    }
    
    
    #match to CurationDrug  
    
    matchToIDTableDRUG <- function(ids,tbl, column) {
      sapply(ids,function(x) {
        myx <- grep(paste0("((///)|^)",x,"((///)|$)"), tbl[,column])
        if(length(myx) > 1){
          stop("Something went wrong in curating drug ids")
        }
        return(tbl[myx, "unique.drugid"])
      })
    }
    
    

    
    load(commandArgs(trailingOnly=TRUE)[1])
    load(commandArgs(trailingOnly=TRUE)[2])
    load(commandArgs(trailingOnly=TRUE)[3])
    load(commandArgs(trailingOnly=TRUE)[4])
    load(commandArgs(trailingOnly=TRUE)[5])
   
    
    sensitivityData_final <- lapply(sensitivityData, function(x){
      ibx <- rownames(x$info)[x$info$drug=="nothing"]
      
      if(length(ibx)!=0){
        x$info <- x$info[-match(ibx,rownames(x$info)),,drop=F]
        x$profile <- x$profile[-match(ibx,rownames(x$profile)),,drop=F]
        x$raw <- x$raw[-match(ibx,rownames(x$raw)),,,drop=F]
        x$raw.complete <- x$raw.complete[-match(ibx,rownames(x$raw.complete)),,,drop=F]
      }
      return(x)
    })
    
    sensitivityData <- sensitivityData_final
    
    rm(sensitivityData_final)
    
    metaData <- lapply(sensitivityData, function(x){
      
      xx <- x$info
      xx[,"exp"] <- rownames(xx)
      rownames(xx)<-NULL
      
      
      return(xx)
      
    })
    
    metaData <- do.call(rbind, metaData)
    
    sum(duplicated(metaData$exp)) ## 84 duplicates
    
    table(metaData$cell)
    table(metaData$drug)
    
    cell_unannot <- unique(metaData$cell)
    
    cell_annot <- gsub(x=cell_unannot, pattern="^[0-9]+-", replacement="")
    cell_annot <- gsub(cell_annot,pattern = "_2",replacement = "")
    cell_annot <- toupper(cell_annot)
    
    cell_unannot <- cell_unannot[order(cell_annot)]
    cell_annot <- cell_annot[order(cell_annot)]
    
    cellMatch <- data.frame("annotated"=cell_annot, "unannotated"=cell_unannot)
    
    
    badchars <- "[\xb5]|[]|[ ,]|[;]|[:]|[-]|[+]|[*]|[%]|[$]|[#]|[{]|[}]|[[]|[]]|[|]|[\\^]|[/]|[\\]|[.]|[_]|[ ]"
    
    
    closeMatches <- lapply(cellMatch[,"annotated"], function(x){
      myx <- cell_all$unique.cellid[which(x == toupper(cell_all[,"unique.cellid"]))]
      if(length(myx)==0){
        if(grepl(pattern="^MDA", x) && x!="MDA361-20%" && x!="MDA143"){ ## different way of writing these cell lines 
          print(x)
          x <- paste(strsplit(x, split="A")[[1]][1], "A", "MB",  strsplit(x, split="A")[[1]][2])
          #      print(x)
        }
        if(grepl(pattern="^UAC[1-9]+", x)){ #common typo
          print(x)
          x <- paste(strsplit(x, split="C")[[1]][1], "CC", strsplit(x, split="C")[[1]][2])
        }
        myx <- grep(pattern=toupper(gsub(badchars, "",x)), x=toupper(gsub(badchars, "",cell_all$unique.cellid)))
        myx <- cell_all$unique.cellid[myx]
      }
      
      
      if(x=="MFN223"){
        myx <- "MFM-223"
      } ## typo in data
      if(x=="AU655"){
        myx <- "AU565"
        print(x)
      } ## typo in data
      if(x=="HCL70"){
        myx <- "HCC70"
      } ## typo in data
      if(x=="MPE600"){
        myx <- "600MPE"
      } ## typo in data
      if(x=="MDA361-20%"){
        print(x)
        myx <- "MDA-MB-361"
      } ## typo in data 
      if(x=="436"){
        print(x)
        myx <- "MDA-MB-436"
      } ## typo in data 
      if(x=="MDA143"){
        myx <- "MDA-MB-134-VI"
        print(x)
        #    print(myx)
      } ## typo in data
      if(x=="OCUB-1" | x=="OCUB1"){
        myx <- "OCUB-M"
      } 
      if(x=="ACC202"){
        print(x)
        myx <- "HCC202"
      }## Closest match (is child of cell line)
      return(ifelse(length(myx)>0,myx,NA))
    })
    sum(!sapply(closeMatches,is.na))
    
    
    cellMatch[,"closeMatches"] <- unlist(closeMatches)
    
    warning("All matches are now OK, but this may change if other cells are added in the future")
    cellMatch$annotated[!is.na(cellMatch$closeMatches)] <- na.omit(cellMatch$closeMatches)
    metaData$newcell <- cellMatch$annotated[match(metaData$cell, cellMatch$unannotated)]
    metaData$newexp <- paste(metaData$newcell, metaData$drug, sep="_")
    for (exp in unique(metaData$newexp)){
      myx <- which(metaData$newexp == exp)
      metaData$newexp[myx] <- paste(metaData$newexp[myx], rep("rep", length(myx)), 1:length(myx), sep="_")
    }
    profilesData <- lapply(sensitivityData, function(x){
      xx <- x$profile
      rownames(xx)<-NULL
      return(xx)
    })
    profilesData <- do.call(rbind, profilesData)
    rownames(profilesData) <- metaData$newexp
    require(abind)
    rawData <- lapply(sensitivityData, function(x){
      xx <- x["raw"]
      rownames(xx)<-NULL
      return(xx)
    })
    
    maxConc <- max(unlist(lapply(rawData, function(x){
      return(dim(x[[1]])[2])
    })))
    
    for (i in 1:length(rawData)) {
      currentDim <- dim(rawData[[i]][[1]])[2]
      if(currentDim<maxConc){
        remainingDim <- maxConc-currentDim
        tmpRaw <- array(NA, dim=c(dim(rawData[[i]][[1]])[1], remainingDim,dim(rawData[[i]][[1]])[3]), dimnames=list(NULL, NULL, unlist(dimnames(rawData[[i]][[1]])[[3]])))
        finalRaw <- array(NA, dim=c(dim(rawData[[i]][[1]])[1], maxConc,dim(rawData[[i]][[1]])[3]), dimnames=list(NULL, NULL, unlist(dimnames(rawData[[i]][[1]])[[3]])))
        for (j in 1:dim(rawData[[i]][[1]])[1]) {
          finalRaw[j,,] <- rbind(rawData[[i]][[1]][j,,],tmpRaw[j,,])
        }
        
        rawData[[i]] <- finalRaw
        
      }else{
        rawData[[i]] <- rawData[[i]][[1]]
      }
    }
    
    lapply(rawData, function(x){
      print(dim(x))
    })
    
    rawData <- abind( rawData, along=1)
    dimnames(rawData)[[1]] <- metaData$newexp
    rownames(metaData) <- metaData$newexp
    ####### bind everything dtogether 
    metaData[,c("cell", "exp","newexp")] <- NULL
    colnames(metaData) <- gsub(pattern="new", x=colnames(metaData), replace="")
    colnames(metaData) <- c("drugid", "file", "cellid")
    metaData <- metaData[,c("drugid", "cellid", "file")]
    sensitivity <- list(info=metaData, profiles=profilesData, raw=rawData)
    
    
    x2 <- matchToIDTableDRUG(sensitivity$info[, "drugid"], curationDrug, "UHNBreast.drugid")
    x2 <- as.character(x2)
    sensitivity$info[, "drugid"] <- x2
    
    
    x3 <- matchToIDTableCELL(tolower(gsub(badchars, "",sensitivity$info[,"cellid"])), curationCell, "Ben_Neel.cellid")
    x3 <- as.character(x3)
    sensitivity$info[, "cellid"] <- x3
    
    
    ## drug information
    druginfo <- data.frame("drugid"=curationDrug$unique.drugid)
    rownames(druginfo) <- druginfo$drugid
    
    
    
    #RNAseq Processed
    
    load(commandArgs(trailingOnly=TRUE)[6])
    
    
    #RPPA Processed
    
    load(commandArgs(trailingOnly=TRUE)[7])
    
    
    #CNA Processed
    
    load(commandArgs(trailingOnly=TRUE)[8])
    
    
    #miRNA Processed

    load(commandArgs(trailingOnly=TRUE)[9])
    
    
    z <- c(z,c(
      "rnaseq.exp"=RNA_exp_processed,
      "rppa"=RPPA_processed,
      "cna"=CNA_processed,
      "mirna"=miRNA_processed)
    )
    
    UHNBreast2019 <- PharmacoSet(name="UHNBreast", 
                                molecularProfiles = z,
                                cell= cellineinfo,
                                drug=druginfo,
                                sensitivityInfo= sensitivity$info,
                                sensitivityRaw = sensitivity$raw,
                                sensitivityProfiles=sensitivity$profiles,
                                curationCell=curationCell, 
                                curationDrug=curationDrug,
                                curationTissue=curationTissue, 
                                datasetType="sensitivity")
    save(UHNBreast2019,file="UHN_2019.RData")
    
   
   return(UHNBreast2019)
    
    

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

getUHN(verbose = FALSE, nthread = 1)


