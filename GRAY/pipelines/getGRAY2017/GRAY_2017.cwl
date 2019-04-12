#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-gray2017:
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

 GRAYrecomputed2017:
   type: File
   inputBinding:
      position: 7

 rnaseq:
   type: File
   inputBinding:
      position: 8

 rppa:
   type: File
   inputBinding:
      position: 9

 rna:
   type: File
   inputBinding:
      position: 10

 cnv:
   type: File
   inputBinding:
      position: 11

 methylation:
   type: File
   inputBinding:
      position: 12


baseCommand: [ Rscript ]

outputs:
 GRAY2017:
  type: File
  outputBinding:
   glob: GRAY_2017.RData