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
  uhn2017Rscript: File


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
    run: ../Cellline_Info/2017/UHN_CelllineInfo.cwl
    in:
      cellcuration: compilecellcuration/cellcuration
      get-celllineinfo: celllineinfoRscript
      published_info: celllinespublished
    out:
      - celllineinfo

  recomputation:
    run: ../Drug_Recomputed/2017/UHN_Recomputed2017.cwl
    in:
      get-recomputed2017: recomputedRscript
      drug_raw2017: drugraw
      computescript: computeRscript

    out:
      - UHNrecomputed2017

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

  getUHN2017PSet:
    run: ../getUHN2017/UHN_2017.cwl
    in:
      get-uhn2017: uhn2017Rscript
      cellcuration: compilecellcuration/cellcuration
      tissuecuration: compiletissuecuration/tissuecuration
      drugcuration: compiledrugcuration/drugcuration
      celllineinfo: compilecelllineinfo/celllineinfo
      UHNrecomputed2017: recomputation/UHNrecomputed2017
      rnaseq: compileRNAseq/rnaseq
      rppa: compileRPPA/rppa
      cna: compileCNA/cna
      mirna: compilemiRNA/mirna

    out:
     - UHN2017



outputs:
 info:
  type: File
  outputSource: getUHN2017PSet/UHN2017