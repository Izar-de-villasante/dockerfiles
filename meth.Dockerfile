
FROM rocker/r-ver:4.2.1

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/rocker-org/rocker-versioned2" \
      org.opencontainers.image.vendor="Rocker Project" \
      org.opencontainers.image.authors="Carl Boettiger <cboettig@ropensci.org>"

ENV DEBIAN_FRONTEND noninteractive
ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2022.07.2+576
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV QUARTO_VERSION=default

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_quarto.sh prerelease
RUN  printf "Y\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nY" | quarto install extension jmbuhr/quarto-molstar 

EXPOSE 8787
# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:latest

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    g++\
    gcc\
    libxml2\
    libxslt-dev\
    libcairo2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    coinor-libcbc-dev coinor-libclp-dev libglpk-dev


## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# copy necessary files
## app folder

# Docker inheritance
FROM bioconductor/bioconductor_docker:devel

RUN apt-get update
    RUN R -e 'BiocManager::install(ask = F)' && R -e 'BiocManager::install(c(\
    "Biostrings", "SummarizedExperiment",  ask = F))'
# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'install.packages("devtools")'
RUN Rscript -e 'install.packages("readxl")'
RUN Rscript -e 'install.packages("targets")'
RUN Rscript -e 'install.packages("data.table")'

RUN apt-get install ssh-client
CMD ["/init"]
