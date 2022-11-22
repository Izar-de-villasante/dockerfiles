#Steps to download and use rstudio custom images from github packages https://github.com/features/packages:

#1. Make sure you can see the image and have permissions (owner/admin must grant them).

#2. Make sure you have Access token set up properly, you can set this up on github and login to docker:
#   More info about this @ link

export CR_PAT=your_access_token_here
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin

#3.Now you have logged in you can use docker api to download your docker image from github containers.
# Here we are going to use shinymeth.sif (since rstudio rocker img + quarto  with shinylive + molstar extensions):
singularity pull shinymeth.sif docker://ghcr.io/izarvillasante/shinymeth:latest

#4.Now we can use the little helper script to run the rstudio image we just downloaded:
./run.sh shinymeth.sif #rember to change shinymeth.sif to whatever name you choose for your singularity image in the previous step

#5. Open rstudio in your browser at port 8787 and start enjoying:
 https://localhost:8787

