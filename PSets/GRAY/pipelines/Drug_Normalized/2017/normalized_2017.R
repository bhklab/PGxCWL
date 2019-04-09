#http://datadryad.org/resource/doi:10.5061/dryad.03n60
##GR values
gray.GRvalues <- read.csv("/pfs/normalizedGRAY2017/DS2_datafile.tsv", header=T, stringsAsFactors=FALSE, sep="\t")

dd <- which(duplicated(gray.GRvalues))
gray.GRvalues <- gray.GRvalues[-dd,]
gray.GRvalues <- gray.GRvalues[-which(gray.GRvalues[, "Small.Molecule.HMS.LINCS.ID.1"]==""),]
##DS1 contains normalized growth rate (which is not applicable in out case, we need viabilitied for AUC which is available through synapse)
#https://www.synapse.org/#!Synapse:syn8094063.1


getGRAYrawData <-
  function(path.data=file.path("/pfs", "GRAY"), result.type=c("array", "list")){

    gray.raw.drug.sensitivity <- read.csv("/pfs/normalizedGRAY2017/Gray_data_raw_dose_response.csv", header=T, row.names=1, stringsAsFactors=FALSE)
    gray.raw.drug.sensitivity.list <- do.call(c, apply(gray.raw.drug.sensitivity, 1, list))
    gray.conc <- read.csv("/pfs/normalizedGRAY2017/Gray_drug_conc.csv", header=T, row.names=1, stringsAsFactors=FALSE)

    concentrations.no <- 9

    if(result.type == "array"){
      ## create the gray.drug.response object including information viablilities and concentrations for each cell/drug pair
      obj <- array(NA, dim=c(length(unique(gray.raw.drug.sensitivity[ , "cellline"])), length(unique(gray.raw.drug.sensitivity[ , "drug"])), 2, concentrations.no), dimnames=list(unique(gray.raw.drug.sensitivity[ , "cellline"]), unique(gray.raw.drug.sensitivity[ , "drug"]), c("concentration", "viability"), 1:concentrations.no))
    }
    fnexperiment <-
      function(values){
        cellline <- values["cellline"]
        drug <- values["drug"]
        values["drug_group_id"] <- gsub(" ", "", values["drug_group_id"]) #removes space from drug-id values -i.e. (" 50") - which was causing some values AUC/IC50 values to not be matched
        doses <- as.numeric(gray.conc[which(gray.conc[,"drug_group_id"] == values["drug_group_id"] & gray.conc[,"drug"] == values["drug"]), grep("^c", colnames(gray.conc))]) * 10 ^ 6 # micro molar

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
          obj[cellline,drug, "concentration", 1:length(doses)] <<- doses
          obj[cellline,drug, "viability", 1:length(responses)] <<- responses
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
raw.sensitivity <- getGRAYrawData(result.type="list")
save(raw.sensitivity, file="/pfs/out/drug_norm2017.RData")

