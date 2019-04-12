library(PharmacoGxPrivate)
library(PharmacoGx)
library(readxl)
library(openxlsx)

options(stringsAsFactors=FALSE)
exp= commandArgs(trailingOnly=TRUE)[1]
proteininfo= commandArgs(trailingOnly=TRUE)[2]
proteinfeature= commandArgs(trailingOnly=TRUE)[3]

RPPA_processed <- read.xlsx(exp, sheet = 4, startRow = 8, cols = c(6:218))
RPPA_processed[,c("X1","X2", "X3", "X4", "X5")] <- NULL
RPPA_info <- read.csv(file=proteininfo, row.names = 1)
RPPA_feature <- read.csv(file=proteinfeature, row.names = 1)
colnames(RPPA_processed) <- RPPA_feature$proteinid
rownames(RPPA_processed) <- RPPA_info$cellid
RPPA_processed <- t(RPPA_processed)
RPPA_processed <- as.matrix(RPPA_processed)
RPPA_processed <- Biobase::ExpressionSet(RPPA_processed)
pData(RPPA_processed) <- RPPA_info
fData(RPPA_processed) <- RPPA_feature
annotation(RPPA_processed) <- "RPPA"


save(RPPA_processed, file="RPPA_processed.RData")