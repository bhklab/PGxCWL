#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogx:v2

inputs:

 get-drugpublished:
   type: File
   inputBinding:
      position: 1

 drug_published:
   type: File
   inputBinding:
      position: 2

baseCommand: [ Rscript ]

outputs:
 GRAYpublished:
  type: File
  outputBinding:
   glob: GRAYpublished.RData