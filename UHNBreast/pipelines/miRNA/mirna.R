library(PharmacoGxPrivate)
library(PharmacoGx)
library(readxl)
library(openxlsx)
library(CoreGx)


options(stringsAsFactors=FALSE)
exp = commandArgs(trailingOnly=TRUE)[1]
mirnainfo = commandArgs(trailingOnly=TRUE)[2]
mirnafeature = commandArgs(trailingOnly=TRUE)[3]



miRNA_processed <- read.csv(file=exp, sep = "\t", check.names = FALSE)
mirna_info <- read.csv(file=mirnainfo, row.names = 1)
mirna_feature <- read.xls(mirnafeature, sheet = 1)
rownames(miRNA_processed) <- miRNA_processed$accession_id
annot_match <- mirna_feature[match(rownames(miRNA_processed), mirna_feature$Mature1_Acc),]
annot_match$Mature1_Acc <- miRNA_processed$accession_id
rownames(annot_match) <- annot_match$Mature1_Acc
miRNA_processed[,c("probe_class", "probe_name", "accession_id")] <- NULL
colnames(miRNA_processed) <- rownames(mirna_info)
annot_match <- annot_match[,c(1:10)]
miRNA_processed <- as.matrix(miRNA_processed)
miRNA_processed <- Biobase::ExpressionSet(miRNA_processed)
pData(miRNA_processed) <- mirna_info
fData(miRNA_processed) <- annot_match
annotation(miRNA_processed) <- "mirna"



save(miRNA_processed, file="miRNA_processed.RData")