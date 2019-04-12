#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-celllineinfo:
   type: File
   inputBinding:
      position: 1

 published_info:
   type: File
   inputBinding:
      position: 2

 cellcuration:
   type: File
   inputBinding:
      position: 3

baseCommand: [ Rscript ]

outputs:
 celllineinfo:
  type: File
  outputBinding:
   glob: cellline_info.RData