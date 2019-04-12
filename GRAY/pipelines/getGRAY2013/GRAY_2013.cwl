#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-gray2013:
   type: File
   inputBinding:
      position: 1

 cellcuration:
   type: File
   inputBinding:
      position: 2

 tissuecuration:
   type: File
   inputBinding:
      position: 3

 drugcuration:
   type: File
   inputBinding:
      position: 4

 celllineinfo:
   type: File
   inputBinding:
      position: 5

 drugnormpost:
   type: File
   inputBinding:
      position: 6

 GRAYrecomputed2013:
   type: File
   inputBinding:
      position: 7

 GRAYpublished:
   type: File
   inputBinding:
      position: 8

 rnaseq:
   type: File
   inputBinding:
      position: 9

 rppa:
   type: File
   inputBinding:
      position: 10

 rna:
   type: File
   inputBinding:
      position: 11

 cnv:
   type: File
   inputBinding:
      position: 12

 methylation:
   type: File
   inputBinding:
      position: 13


baseCommand: [ Rscript ]

outputs:
 GRAY2013:
  type: File
  outputBinding:
   glob: GRAY_2013.RData