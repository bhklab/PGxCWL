#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogx:v2

inputs:

 get-drugcuration:
   type: File
   inputBinding:
      position: 1

 drug_annotation:
   type: File
   inputBinding:
      position: 2

baseCommand: [ Rscript ]

outputs:
 drugcuration:
  type: File
  outputBinding:
   glob: drug_cur.RData