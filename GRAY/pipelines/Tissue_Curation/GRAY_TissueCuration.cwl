#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-tissuecuration:
   type: File
   inputBinding:
      position: 1

 tissue_annotation:
   type: File
   inputBinding:
      position: 2

 cellcuration:
   type: File
   inputBinding:
      position: 3
 


baseCommand: [ Rscript ]

outputs:
 tissuecuration:
  type: File
  outputBinding:
   glob: tissue_cur.RData