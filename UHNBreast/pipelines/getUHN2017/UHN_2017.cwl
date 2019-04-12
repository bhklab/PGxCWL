#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-uhn2017:
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

 UHNrecomputed2017:
   type: File
   inputBinding:
      position: 6

 rnaseq:
   type: File
   inputBinding:
      position: 7

 rppa:
   type: File
   inputBinding:
      position: 8

 cna:
   type: File
   inputBinding:
      position: 9

 mirna:
   type: File
   inputBinding:
      position: 10


baseCommand: [ Rscript ]

outputs:
 UHN2017:
  type: File
  outputBinding:
   glob: UHN_2017.RData