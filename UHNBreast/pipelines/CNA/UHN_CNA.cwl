#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
 DockerRequirement:
  dockerPull: bhklab/pharmacogxcwl

inputs:

 get-cna:
   type: File
   inputBinding:
      position: 1

 snp6:
   type: File
   inputBinding:
      position: 3

 cnainfo:
   type: File
   inputBinding:
      position: 4

 cnafeature:
   type: File
   inputBinding:
      position: 5


baseCommand: [ Rscript ]

outputs:
 cna:
  type: File
  outputBinding:
   glob: CNA_processed.RData