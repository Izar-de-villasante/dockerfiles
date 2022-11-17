FROM idevillasante/ptpn11:quatro-dev

# Get and install system dependencies
RUN R -e "install.packages('remotes')" \
 && R -e "remotes::install_github('r-hub/sysreqs')"

WORKDIR $1
COPY DESCRIPTION DESCRIPTION
RUN sudo apt update \
 && R -e "system(sysreqs::sysreq_commands('DESCRIPTION', 'linux-x86_64-ubuntu-gcc'))" \
 && apt install -y libmagick++-dev
RUN apt-get install ssh-client
RUN apt-get install g++ gcc libxml2 libxslt-dev -y 
# Get and install R packages to local library
COPY renv.lock renv.lock
COPY renv/activate.R renv/activate.R
COPY .Rprofile .Rprofile
RUN chown -R rstudio . \
 && sudo -u rstudio R -e 'renv::restore()'

# Copy data to image
COPY data data
