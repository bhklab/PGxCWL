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
   type: File
   inputBinding:
      position: 2

 drug_conc2017:
   type: File
   inputBinding:
      position: 3

 GRValues:
   type: File
   inputBinding:
      position: 4

 crosscell:
   type: File
   inputBinding:
      position: 5

 crossdrug:
   type: File
   inputBinding:
      position: 6

 computed2013sens:
   type: File
   inputBinding:
      position: 7
 


baseCommand: [ Rscript ]

outputs:
 drugnormpost:
  type: File
  outputBinding:
   glob: drug_norm_post2017.RData

 GRAYrecomputed2017:
  type: File
  outputBinding:
   glob: GRAYrecomputed_2017.RData