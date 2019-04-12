library(PharmacoGxPrivate)
library(PharmacoGx)


options(stringsAsFactors=FALSE)
exp = commandArgs(trailingOnly=TRUE)[1]
cnainfo = commandArgs(trailingOnly=TRUE)[2]
ensemblannot = commandArgs(trailingOnly=TRUE)[3]


    CNA_processed <- read.csv(file=exp, sep = "\t", check.names = FALSE)
    CNA_info <- read.csv(file=cnainfo, row.names = 1)
    rownames(CNA_processed) <- CNA_processed$ensembl_id
    annot_gene <- read.csv(file=ensemblannot,row.names = 1)
    annot_match <- annot_gene[match(rownames(CNA_processed), rownames(annot_gene)),c("gene_id", "EntrezGene.ID", "gene_name", "gene_biotype")]
    rownames(annot_match) <- rownames(CNA_processed)
    annot_match$gene_id <- CNA_processed$gene_id
    CNA_processed[,c("symbol","gene_id","ensembl_id")] <- NULL
    colnames(CNA_processed) <- rownames(CNA_info)
    CNA_processed <- as.matrix(CNA_processed)
    CNA_processed <- Biobase::ExpressionSet(CNA_processed)
    pData(CNA_processed) <- CNA_info
    fData(CNA_processed) <- annot_match
    annotation(CNA_processed) <- "CNA"





save(CNA_processed, file="CNA_processed.RData")