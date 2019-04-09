
##sensitivity
getGRAYrawData <-
  function(result.type=c("array", "list")){
    
    drug_raw = commandArgs(trailingOnly=TRUE)[1]
    gray.raw.drug.sensitivity <- read.csv(file = drug_raw ,header = TRUE, sep = "\t",stringsAsFactors = FALSE)
    gray.raw.drug.sensitivity.list <- do.call(c, apply(gray.raw.drug.sensitivity, 1, list))
    
    concentrations.no <- length(grep("^c[1-9]", colnames(gray.raw.drug.sensitivity)))
    
    if(result.type == "array"){
      ## create the gray.drug.response object including information viablilities and concentrations for each cell/drug pair
      obj <- array(NA, dim=c(length(unique(gray.raw.drug.sensitivity[ , "cellline"])), length(unique(gray.raw.drug.sensitivity[ , "compound"])), 2, concentrations.no), dimnames=list(unique(gray.raw.drug.sensitivity[ , "cellline"]), unique(gray.raw.drug.sensitivity[ , "compound"]), c("concentration", "viability"), 1:concentrations.no))
    }
    fnexperiment <-
      function(values){
        cellline <- values["cellline"]
        drug <- values["compound"]
        doses <- as.numeric(values[grep("^c[1-9]", names(values))]) * 10 ^ 6 # micro molar
        
        if(concentrations.no > length(doses)) {doses <- c(doses, rep(NA, concentrations.no - length(doses)))}
        
        #responses <- as.numeric(unlist(strsplit(input.matrix["Activity Data\n(raw median data)"], split=",")))  #nature paper raw data
        
        responses <- NULL
        background <- median(as.numeric(values[grep("^background_od", names(values))]))
        ctrl <- median(as.numeric(values[sprintf("od%s.%s",0,1:3)])) - background
        ctrl <- ifelse(ctrl < 0, 1, ctrl)
        for( i in 1:concentrations.no)
        {
          res <- median(as.numeric(values[sprintf("od%s.%s",i, 1:3)])) - background
          res <- ifelse(res < 0, 0, res)
          responses <- c(responses, res/ctrl)
        }
        responses <- responses * 100
        if(result.type == "array"){
          obj[cellline,drug, "concentration", 1:9] <<- doses
          obj[cellline,drug, "viability", 1:9] <<- responses
        }else{
          return(list(cell=cellline, drug=drug, doses=doses, responses=responses))#paste(doses, collapse = ","), responses=paste(responses, collapse = ",")))
        }
      }
    
    gray.raw.drug.sensitivity.res <- mapply(fnexperiment, values=gray.raw.drug.sensitivity.list)
    if(result.type == "array"){
      
      return(list("data"=obj, "concentrations.no"=concentrations.no))
    }else{
      return(list("data"=gray.raw.drug.sensitivity.res, "concentrations.no"=concentrations.no))
    }
  }

library(PharmacoGxPrivate)
library(readr)
library(tximport)
library(rhdf5)
library(gdata)
library(readxl)
library(openxlsx)

raw.sensitivity <- getGRAYrawData(result.type="list")

save(raw.sensitivity, file="GRAYnormalized_2013.RData") 



