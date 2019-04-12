#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:
  cellcurationRscript: File
  celllines: File
  tissuecurationRscript: File
  tissues: File
  drugcurationRscript: File
  drugs: File
  celllinespublished: File
  celllineinfoRscript: File
  drugraw: File
  recomputedRscript: File
  publishedRscript: File
  drugpublished: File
  rnaseqRscript: File
  rnaseqmatrix: File
  rnaseqpdata: File
  rnaseqfdata: File
  rnaseqexp: File
  rnaseqcounts: File
  rppaRscript: File
  rppaexp: File
  rppapdata: File
  rppafdata: File
  rnaRscript: File
  rnau133aexp: File
  rnau133apdata: File
  rnau133afdata: File
  rnaexonexp: File
  rnaexonpdata: File
  rnaexonfdata: File
  cnvRscript: File
  snpexp: File
  cnvpdata: File
  cnvfdata: File
  methylationRscript: File
  methylationmatrix: File
  methylationpdata: File
  methylationfdata: File
  gray2013Rscript: File


steps:
  compilecellcuration:
    run: ../Cell_Curation/GRAY_CellCuration.cwl
    in:
      get-cellcuration: cellcurationRscript
      cell_annotation: celllines
    out:
     - cellcuration

  compiletissuecuration:
    run: ../Tissue_Curation/GRAY_TissueCuration.cwl
    in:
      cellcuration: compilecellcuration/cellcuration
      get-tissuecuration: tissuecurationRscript
      tissue_annotation: tissues
    out:
     - tissuecuration


  compiledrugcuration:
    run: ../Drug_Curation/GRAY_DrugCuration.cwl
    in:
      get-drugcuration: drugcurationRscript
      drug_annotation: drugs
    out:
     - drugcuration


  compilecelllineinfo:
    run: ../Cellline_Info/GRAY_CelllineInfo.cwl
    in:
      cellcuration: compilecellcuration/cellcuration
      get-celllineinfo: celllineinfoRscript
      published_info: celllinespublished
    out:
      - celllineinfo

  recomputation:
    run: ../Drug_Recomputed/2013/GRAY_Recomputed2013.cwl
    in:
      drug_raw2013: drugraw
      get-recomputed2013: recomputedRscript

    out:
      - drugnormpost
      - GRAYrecomputed2013

  compiledrugpublished:
    run: ../Drug_Published/GRAY_Published.cwl
    in:
      get-drugpublished: publishedRscript
      drug_published: drugpublished
    out:
     - GRAYpublished

  compileRNAseq:
    run: ../RNAseq/GRAY_RNAseq.cwl
    in:
      get-rnaseq: rnaseqRscript
      cellcuration: compilecellcuration/cellcuration
      matrix: rnaseqmatrix
      rnaseqinfo: rnaseqpdata
      rnaseqfeature: rnaseqfdata
      expression: rnaseqexp
      counts: rnaseqcounts
    out:
     - rnaseq

  compileRPPA:
    run: ../RPPA/GRAY_RPPA.cwl
    in:
      get-rppa: rppaRscript
      expression: rppaexp
      proteininfo: rppapdata
      proteinfeature: rppafdata
    out:
     - rppa

  compileRNA:
    run: ../RNA/GRAY_RNA.cwl
    in:
      get-rna: rnaRscript
      u133aexp: rnau133aexp
      u133ainfo: rnau133apdata
      u133afeature: rnau133afdata
      exonexp: rnaexonexp
      exoninfo: rnaexonpdata
      exonfeature: rnaexonfdata

    out:
     - rna

  compileCNV:
    run: ../CNV/GRAY_CNV.cwl
    in:
      get-cnv: cnvRscript
      snp6: snpexp
      cnvinfo: cnvpdata
      cnvfeature: cnvfdata

    out:
     - cnv

  compileMethylation:
    run: ../Methylation/GRAY_Methylation.cwl
    in:
      get-methylation: methylationRscript
      matrix: methylationmatrix
      methylationinfo: methylationpdata
      methylationfeature: methylationfdata

    out:
     - methylation

  getGRAY2013PSet:
    run: ../getGRAY2013/GRAY_2013.cwl
    in:
      get-gray2013: gray2013Rscript
      cellcuration: compilecellcuration/cellcuration
      tissuecuration: compiletissuecuration/tissuecuration
      drugcuration: compiledrugcuration/drugcuration
      celllineinfo: compilecelllineinfo/celllineinfo
      drugnormpost: recomputation/drugnormpost
      GRAYrecomputed2013: recomputation/GRAYrecomputed2013
      GRAYpublished: compiledrugpublished/GRAYpublished
      rnaseq: compileRNAseq/rnaseq
      rppa: compileRPPA/rppa
      rna: compileRNA/rna
      cnv: compileCNV/cnv
      methylation: compileMethylation/methylation

    out:
     - GRAY2013



outputs:
 info:
  type: File
  outputSource: getGRAY2013PSet/GRAY2013