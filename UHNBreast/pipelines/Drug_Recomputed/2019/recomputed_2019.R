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
    
    i1 <- grep("12_03_2015",viabilityFiles)
    i2 <- grep("12_08_2015",viabilityFiles)
    i3 <- grep("12_09_2015",viabilityFiles)
    i4 <- grep("12_15_2015",viabilityFiles)
    i5 <- grep("1_13_2016",viabilityFiles)
    i6 <- grep("1_21_2016",viabilityFiles)
    i7 <- grep("1_26_2016",viabilityFiles)
    i8 <- grep("2_09_2016",viabilityFiles)
    i9 <- grep("11_28_2016",viabilityFiles)
    i10 <- grep("12_1_2016",viabilityFiles)
    i11 <- grep("12_6_2016",viabilityFiles)
    i12 <- grep("12_9_2016",viabilityFiles)
    i13 <- grep("12_14_2016",viabilityFiles)
    i14 <- grep("12_16_2016",viabilityFiles)
    i15 <- grep("1_4_2017",viabilityFiles)
    i16 <- grep("1_11_2017",viabilityFiles)
    i17 <- grep("1_18_2017",viabilityFiles)
    i18 <- grep("1_31_2017",viabilityFiles)

viabilityFiles <- viabilityFiles[c(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18)]

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

save(sensitivityData,file = "UHNRecomputed_2019.RData")




