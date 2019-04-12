#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-rna:
   type: File
   inputBinding:
      position: 1

 u133aexp:
   type: File
   inputBinding:
      position: 2

 u133ainfo:
   type: File
   inputBinding:
      position: 3

 u133afeature:
   type: File
   inputBinding:
      position: 4

 exonexp:
   type: File
   inputBinding:
      position: 5

 exoninfo:
   type: File
   inputBinding:
      position: 6

 exonfeature:
   type: File
   inputBinding:
      position: 7

baseCommand: [ Rscript ]

outputs:
 rna:
  type: File
  outputBinding:
   glob: RNA_processed.RData