#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-mirna:
   type: File
   inputBinding:
      position: 1

 matrix:
   type: File
   inputBinding:
      position: 2

 mirnainfo:
   type: File
   inputBinding:
      position: 3

 mirnafeature:
   type: File
   inputBinding:
      position: 4


baseCommand: [ Rscript ]

outputs:
 mirna:
  type: File
  outputBinding:
   glob: miRNA_processed.RData