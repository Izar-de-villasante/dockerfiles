module load singularity-3.8.3-gcc-11.2.0-rlxj6fi
source ~/.credentials


PASSWORD=${password} singularity exec    --bind run:/run,var-lib-rstudio-server:/var/lib/rstudio-server,database.conf:/etc/rstudio/database.conf    $1    /usr/lib/rstudio-server/bin/rserver --auth-none=0 --auth-pam-helper-path=pam-helper --server-user=${USER}
