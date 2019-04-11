FROM bioconductor/release_core2

USER root



RUN apt-get update && apt-get install -y openssl libssl-dev curl libcurl4-openssl-dev libxml2-dev git tcl tk 
RUN Rscript -e "library(BiocManager); install(c('magicaxis','AnnotationDbi','org.Hs.eg.db','annotate', 'genefilter', 'sva', 'dplyr', 'curl', 'openssl', 'git2r', 'httr', 'httpuv', 'devtools', 'XML'))" 
RUN Rscript -e "install.packages('http://www.cbs.dtu.dk/biotools/jetset/current/jetset_3.4.0.tar.gz', repos = NULL, type = 'source')"
RUN Rscript -e "install.packages('XML', repos = 'https://cran.r-project.org/')"
RUN Rscript -e "library(BiocManager); install(c('caTools', 'piano', 'downloader', 'RColorBrewer', 'magicaxis', 'WriteXLS', 'gdata', 'R.utils','Hmisc', 'affy', 'affxparser', 'affyio', 'frma', 'hthgu133afrmavecs', 'hthgu133acdf', 'hthgu133a.db', 'hgu133a.db', 'hgu133afrmavecs', 'hgu133plus2frmavecs', 'hgu133plus2.db','PharmacoGx', 'lsa'))"
RUN Rscript -e "install.packages('readr')"
RUN Rscript -e "install.packages('abind')"
RUN Rscript -e "install.packages('gdata')"
RUN Rscript -e "install.packages('openxlsx')"
RUN Rscript -e "install.packages('readxl')"
RUN Rscript -e "install.packages('calibrate')"
RUN wget 'https://uhnbreast.blob.core.windows.net/docker/PharmacoGxPrivate_0.0.1.tar.gz'
RUN wget 'https://uhnbreast.blob.core.windows.net/docker/CoreGx_0.0.001.tar.gz'
RUN tar zxvf PharmacoGxPrivate_0.0.1.tar.gz
RUN tar zxvf CoreGx_0.0.001.tar.gz
RUN Rscript -e "library(devtools); install.packages('PharmacoGxPrivate_0.0.1.tar.gz', repos = NULL, type='source')"
RUN Rscript -e "library(devtools); install.packages('CoreGx_0.0.001.tar.gz', repos = NULL, type='source')"
RUN Rscript -e "library(devtools); install_github('bhklab/genefu')"
RUN Rscript -e "library(BiocManager); install('tximport')"
RUN Rscript -e "library(BiocManager); install('rhdf5')"
RUN Rscript -e "library(BiocManager); install('hgu133plus2frmavecs')"
RUN Rscript -e "install.packages('plyr')"
