library(PharmacoGxPrivate)
library(readr)
library(tximport)
library(rhdf5)
library(gdata)
library(readxl)
library(openxlsx)


source(commandArgs(trailingOnly=TRUE)[2])

path = commandArgs(trailingOnly=TRUE)[1]
setwd(path)

print(getwd())

Folder <- "Data"
files <- dir(Folder)

print(files)
    files_fullName <- dir(Folder,full.names = TRUE) 
    
    concenFInd <- grep("^concen",files,ignore.case = T)
    
    concentrationFiles <- files_fullName[concenFInd]
    
    viabilityFInd <- grep("^concen",files,ignore.case = T,invert = T)
    
    viabilityFiles = files_fullName[viabilityFInd]
    
    i1 <- grep("12_09_2015",viabilityFiles)
    i2 <- grep("1_26_2016",viabilityFiles)
    i3 <- grep("1_13_2016",viabilityFiles)
    viabilityFiles <- viabilityFiles[c(i1,i2,i3)]


print(head(viabilityFiles))
print(head(concentrationFiles))

sensitivityData <- lapply(viabilityFiles, function(x, concentration){
      
  concentrationF <- concentration[grep(strsplit(strsplit(x,"-")[[1]][2],"\\.")[[1]][1],concentration)]
      
  print(paste("started:",x))
  print(concentrationF)
  xx <- computeSensitivity(viability = x, concentration = concentrationF)
      
  xx[["info"]][,"file"] = basename(x)
      
  print(paste("finished:",x))
  return(xx)
      
  }, concentration=concentrationFiles)



print(str(sensitivityData))

setwd("~")

save(sensitivityData,file = "UHNRecomputed_2017.RData")




