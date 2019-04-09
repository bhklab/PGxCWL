#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogx:v2

inputs:

 get-cellcuration:
   type: File
   inputBinding:
      position: 1

 cell_annotation:
   type: File
   inputBinding:
      position: 2

baseCommand: [ Rscript ]

outputs:
 cellcuration:
  type: File
  outputBinding:
   glob: cell_cur.RData