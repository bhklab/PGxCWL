#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-recomputed2013:
   type: File
   inputBinding:
      position: 1

 drug_raw2013:
   type: File
   inputBinding:
      position: 2

baseCommand: [ Rscript ]

outputs:
 drugnormpost:
  type: File
  outputBinding:
   glob: drug_norm_post.RData

 GRAYrecomputed2013:
  type: File
  outputBinding:
   glob: GRAYrecomputed_2013.RData