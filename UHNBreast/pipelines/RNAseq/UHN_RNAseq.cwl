#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-rnaseq:
   type: File
   inputBinding:
      position: 1

 matrix:
   type: File
   inputBinding:
      position: 2

 rnaseqinfo:
   type: File
   inputBinding:
      position: 3

 rnaseqfeature:
   type: File
   inputBinding:
      position: 4


baseCommand: [ Rscript ]

outputs:
 rnaseq:
  type: File
  outputBinding:
   glob: RNAseq_processed.RData