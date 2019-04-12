library(PharmacoGxPrivate)
library(PharmacoGx)


options(stringsAsFactors=FALSE)
exp = commandArgs(trailingOnly=TRUE)[1]
rnainfo = commandArgs(trailingOnly=TRUE)[2]
ensemblannot = commandArgs(trailingOnly=TRUE)[3]


RNA_exp_processed <- read.csv(file=exp, sep = "\t", check.names = FALSE)
RNA_info <- read.csv(file=rnainfo, row.names = 1)
rownames(RNA_exp_processed) <- RNA_exp_processed$ensembl_id
annot_gene <- read.csv(ensemblannot, row.names = 1)
annot_match <- annot_gene[match(rownames(RNA_exp_processed), rownames(annot_gene)),c("gene_id", "EntrezGene.ID", "gene_name", "gene_biotype")]
rownames(annot_match) <- rownames(RNA_exp_processed)
annot_match$gene_id <- RNA_exp_processed$gene_id
RNA_exp_processed[,c("symbol","gene_id","ensembl_id")] <- NULL
colnames(RNA_exp_processed) <- rownames(RNA_info)
RNA_exp_processed <- as.matrix(RNA_exp_processed)
RNA_exp_processed <- Biobase::ExpressionSet(RNA_exp_processed)
pData(RNA_exp_processed) <- RNA_info
fData(RNA_exp_processed) <- annot_match
annotation(RNA_exp_processed) <- "RNAseq Exp FPKM"





save(RNA_exp_processed, file="RNAseq_processed.RData")