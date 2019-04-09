#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogx:v2

inputs:

 get-rnaseq:
   type: File
   inputBinding:
      position: 1

 cellcuration:
   type: File
   inputBinding:
      position: 2

 matrix:
   type: File
   inputBinding:
      position: 3

 rnaseqinfo:
   type: File
   inputBinding:
      position: 4

 rnaseqfeature:
   type: File
   inputBinding:
      position: 5

 expression:
   type: File
   inputBinding:
      position: 6

 counts:
   type: File
   inputBinding:
      position: 7

baseCommand: [ Rscript ]

outputs:
 rnaseq:
  type: File
  outputBinding:
   glob: RNAseq_processed.RData