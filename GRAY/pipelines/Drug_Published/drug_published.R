library(PharmacoGxPrivate)
library(PharmacoGx)
library(readr)
library(tximport)
library(rhdf5)
library(gdata)
library(readxl)
library(openxlsx)
library(CoreGx)

options(stringsAsFactors=FALSE)

profile= commandArgs(trailingOnly=TRUE)[1]

profiles <- read.xlsx(profile, sheet = 1)
profiles[!is.na(profiles) & profiles == ""] <- NA
rn <- profiles[-1, 1]
cn <- t(profiles[1, -1])
profiles <- profiles[-1, -1]
dimnames(profiles) <- list(rn, cn)
profiles <- profiles[which(!is.na(profiles[, "Transcriptional subtype"])), ]
colnames(profiles)[which(colnames(profiles) == "L-779450")] <-  "L-779405"
indices <- 11:ncol(profiles) 
profiles <- profiles[1:70, ]
GI50 <- as.numeric(array(apply(profiles, 1, function(x)(x[indices]))))

save(profiles, rn, cn, indices, GI50, file="GRAYpublished.RData")