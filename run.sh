

#export RSTUDIO_WHICH_R=$(which R)
#sudo singularity instance start --writable-tmpfs \
#	    --net --network-args "portmap=8080:8787/tcp" $1 rstudio-serv

mkdir -p -m 770 run tmp var-lib-rstudio-server
cat > database.conf <<END
provider=sqlite
directory=/var/lib/rstudio-server
END


cat > rsession.sh <<END
#!/bin/sh
export R_LIBS_USER=${HOME}/R/rocker-rstudio/4.2
exec /usr/lib/rstudio-server/bin/rsession "\${@}"
END

chmod +x rsession.sh
#export SINGULARITY_BIND="${workdir}/run:/run,${workdir}/tmp:/tmp,${workdir}/database.conf:/etc/rstudio/database.conf,${workdir}/rsession.sh:/etc/rstudio/rsession.sh,${workdir}/var/lib/rstudio-server:/var/lib/rstudio-server"
# #export APPTAINERENV_RSTUDIO_SESSION_TIMEOUT=0
# #export APPTAINERENV_BIND="run:/run,var-lib-rstudio-server:/var/lib/rstudio-server,database.conf:/etc/rstudio/database.conf" 

# local_vol:mounted_vol,

# export APPTAINERENV_BIND="run:/run,tmp:/tmp,database.conf:/etc/rstudio/databse.conf,rsession.sh:/etc/rstudio/rsession.sh,var-lib-rstudio-server:/var/lib/rstudio-server"
# export APPTAINERENV_PASSWORD=password



#singularity exec --cleanenv $1 \
#	    /usr/lib/rstudio-server/bin/rserver --www-port 8787  \
#	    --auth-none=0 \
#	    --auth-pam-helper-path=pam-helper \
#	    --auth-stay-signed-in-days=30 \
#	    --auth-timeout-minutes=0 \
#	    --rsession-path=/etc/rstudio/rsession.sh \
#	    --server-user=${USER}
##
##singularity exec   $1    /usr/lib/rstudio-server/bin/rserver --auth-none=1 --auth-pam-helper-path=pam-helper --server-user=${USER}
##
#singularity exec --bind run:/run,rsession.sh:/etc/rstudio/rsession.sh,var-lib-rstudio-server:/var/lib/rstudio-server,database.conf:/etc/rstudio/database.conf    $1    /usr/lib/rstudio-server/bin/rserver --auth-none=1 --auth-pam-helper-path=pam-helper --server-user=idevillasante --www-port 8788

singularity exec ~/containers/dev.sif which R
PASSWORD=pass singularity exec   --bind /ijc,run:/run,var-lib-rstudio-server:/var/lib/rstudio-server,database.conf:/etc/rstudio/database.conf ~/containers/dev.sif /usr/lib/rstudio-server/bin/rserver --server-user=${USER} --auth-none=1 --auth-pam-helper-path=pam-helper --www-port 8788

printf 'rserver exited' 1>&2

#singularity exec --bind   $1    /usr/lib/rstudio-server/bin/rserver --auth-none=1 --auth-pam-helper-path=pam-helper --server-user=${USER}  
