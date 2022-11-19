FROM ubuntu:22.04
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    python3-pip \
    build-essential libssl-dev libffi-dev python3-dev
    

RUN apt install -y build-essential libssl-dev libffi-dev python3-dev
RUN "Y"|pip3 install shinylive --upgrade
RUN apt-get install -y git-core gcc g++ make libffi-dev libssl-dev python3-dev build-essential libpq-dev libmemcached-dev curl libcairo2-dev
RUN apt-get install -y libtiff5-dev libjpeg-dev libfreetype6-dev webp zlib1g-dev pcre++-dev libpango1.0-dev

RUN apt-get install -y libev-dev
RUN python3 -m pip install jupyter

FROM rocker/r-ver:4
LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/Izar-de-villasante/dockerfiles" \
      org.opencontainers.image.vendor="IJC Bioinformatics Team" \
      org.opencontainers.image.authors="Izar de Villasante <idevillasante@carrerasresearch.org>" \
      org.opencontainers.image.description="Ready to use rstudio + quarto container to start your new projects. This image contains R(4.2) Python(3.8+) rstudio(v2.1.0.2) shiny Bioconductor and quarto (1.2+) and the extensions shinylive and molstar."

ENV DEBIAN_FRONTEND noninteractive
ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=latest  
#2022.07.2+576
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV QUARTO_VERSION=default
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
    coinor-libcbc-dev coinor-libclp-dev libglpk-dev \
    libgtk2.0-dev libxt-dev xvfb xauth xfonts-base

RUN install2.r --error --skipinstalled --ncpus -1 \
    --repos https://ropensci.r-universe.dev --repos getOption \
    renv \
    devtools \
    data.table \
    shiny \
    Cairo \
    && rm -rf /tmp/downloaded_packages \
    && strip /usr/local/lib/R/site-library/*/libs/*.so
RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_quarto.sh prerelease
RUN printf "Y\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nY" | quarto install extension jmbuhr/quarto-molstar 
RUN printf "Y\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nY" | quarto install extension quarto-ext/shinylive
EXPOSE 8787
# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:latest

# system libraries of general use
# install debian packages
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
#RUN Rscript -e 'install.packages("renv")'
#RUN Rscript -e 'install.packages("devtools")'
#RUN Rscript -e 'install.packages("readxl")'
#RUN Rscript -e 'install.packages("targets")'
#RUN Rscript -e 'install.packages("data.table")'


RUN apt-get install ssh-client
EXPOSE 8787
EXPOSE 3838
CMD ["/init"]
