#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-methylation:
   type: File
   inputBinding:
      position: 1

 matrix:
   type: File
   inputBinding:
      position: 2

 methylationinfo:
   type: File
   inputBinding:
      position: 3

 methylationfeature:
   type: File
   inputBinding:
      position: 4

baseCommand: [ Rscript ]

outputs:
 methylation:
  type: File
  outputBinding:
   glob: Methylation_processed.RData