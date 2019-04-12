#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-recomputed2017:
   type: File
   inputBinding:
      position: 1

 drug_raw2017:
   type: Directory
   inputBinding:
      position: 2

 computescript:
   type: File
   inputBinding:
      position: 3
 


baseCommand: [ Rscript ]

outputs:
 UHNrecomputed2017:
  type: File
  outputBinding:
   glob: UHNRecomputed_2017.RData