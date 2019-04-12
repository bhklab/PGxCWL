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
  recomputedRscript: File
  drugraw: Directory
  computeRscript: File
  rnaseqRscript: File
  rnaseqmatrix: File
  rnaseqpdata: File
  rnaseqfdata: File
  rppaRscript: File
  rppaexp: File
  rppapdata: File
  rppafdata: File
  cnaRscript: File
  snpexp: File
  cnapdata: File
  cnafdata: File
  mirnaRscript: File
  mirnamatrix: File
  mirnapdata: File
  mirnafdata: File
  uhn2019Rscript: File


steps:
  compilecellcuration:
    run: ../Cell_Curation/UHN_CellCuration.cwl
    in:
      get-cellcuration: cellcurationRscript
      cell_annotation: celllines
    out:
     - cellcuration

  compiletissuecuration:
    run: ../Tissue_Curation/UHN_TissueCuration.cwl
    in:
      cellcuration: compilecellcuration/cellcuration
      get-tissuecuration: tissuecurationRscript
      tissue_annotation: tissues
    out:
     - tissuecuration


  compiledrugcuration:
    run: ../Drug_Curation/UHN_DrugCuration.cwl
    in:
      get-drugcuration: drugcurationRscript
      drug_annotation: drugs
    out:
     - drugcuration


  compilecelllineinfo:
    run: ../Cellline_Info/2019/UHN_CelllineInfo.cwl
    in:
      cellcuration: compilecellcuration/cellcuration
      get-celllineinfo: celllineinfoRscript
      published_info: celllinespublished
    out:
      - celllineinfo

  recomputation:
    run: ../Drug_Recomputed/2019/UHN_Recomputed2019.cwl
    in:
      get-recomputed2019: recomputedRscript
      drug_raw2019: drugraw
      computescript: computeRscript

    out:
      - UHNrecomputed2019

  compileRNAseq:
    run: ../RNAseq/UHN_RNAseq.cwl
    in:
      get-rnaseq: rnaseqRscript
      matrix: rnaseqmatrix
      rnaseqinfo: rnaseqpdata
      rnaseqfeature: rnaseqfdata

    out:
     - rnaseq

  compileRPPA:
    run: ../RPPA/UHN_RPPA.cwl
    in:
      get-rppa: rppaRscript
      expression: rppaexp
      proteininfo: rppapdata
      proteinfeature: rppafdata
    out:
     - rppa


  compileCNA:
    run: ../CNA/UHN_CNA.cwl
    in:
      get-cna: cnaRscript
      snp6: snpexp
      cnainfo: cnapdata
      cnafeature: cnafdata

    out:
     - cna

  compilemiRNA:
    run: ../miRNA/UHN_miRNA.cwl
    in:
      get-mirna: mirnaRscript
      matrix: mirnamatrix
      mirnainfo: mirnapdata
      mirnafeature: mirnafdata

    out:
     - mirna

  getUHN2019PSet:
    run: ../getUHN2019/UHN_2019.cwl
    in:
      get-uhn2019: uhn2019Rscript
      cellcuration: compilecellcuration/cellcuration
      tissuecuration: compiletissuecuration/tissuecuration
      drugcuration: compiledrugcuration/drugcuration
      celllineinfo: compilecelllineinfo/celllineinfo
      UHNrecomputed2019: recomputation/UHNrecomputed2019
      rnaseq: compileRNAseq/rnaseq
      rppa: compileRPPA/rppa
      cna: compileCNA/cna
      mirna: compilemiRNA/mirna

    out:
     - UHN2019



outputs:
 info:
  type: File
  outputSource: getUHN2019PSet/UHN2019