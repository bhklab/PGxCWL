#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogx:v2

inputs:

 get-normalized2013:
   type: File
   inputBinding:
      position: 1

 drug_raw2013:
   type: File
   inputBinding:
      position: 2

baseCommand: [ Rscript ]

outputs:
 GRAYnormalized2013:
  type: File
  outputBinding:
   glob: GRAYnormalized_2013.RData