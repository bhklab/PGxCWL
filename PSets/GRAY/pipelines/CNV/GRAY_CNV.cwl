#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogx:v2

inputs:

 get-cnv:
   type: File
   inputBinding:
      position: 1

 snp6:
   type: File
   inputBinding:
      position: 2

 cnvinfo:
   type: File
   inputBinding:
      position: 3

 cnvfeature:
   type: File
   inputBinding:
      position: 4

baseCommand: [ Rscript ]

outputs:
 cnv:
  type: File
  outputBinding:
   glob: cnv_processed.RData