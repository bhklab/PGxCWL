#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogx:v2

inputs:

 get-rppa:
   type: File
   inputBinding:
      position: 1

 expression:
   type: File
   inputBinding:
      position: 2

 proteininfo:
   type: File
   inputBinding:
      position: 3

 proteinfeature:
   type: File
   inputBinding:
      position: 4

baseCommand: [ Rscript ]

outputs:
 rppa:
  type: File
  outputBinding:
   glob: RPPA_processed.RData