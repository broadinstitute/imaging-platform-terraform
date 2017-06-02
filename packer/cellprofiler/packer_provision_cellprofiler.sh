#!/bin/bash
# sleep X assures there is enough time for an SSH connection to be established.
# e.g. $ sleep 30
# A more complex solution looks for the existence of a file at */var/lib/cloud/instance/boot-finished*.
# The creation of the *boot-finished* file is a standard Amazon EC2 startup action.
# I'm going to do both, just to be sure. I've seen sporadic performance, i.e. sometimes it works and sometimes it doesn't and the source of the problem is not obvious to me. This seems to help.
while [ ! -f /var/lib/cloud/instance/boot-finished ]
do
  echo "Waiting for AWS cloud-init..." >> waiting_for_AWS_cloud-init.log
  sleep 1
done
sleep 30
#-----------------------------
# Ubuntu
# http://
#-----------------------------
# update Ubuntu and the apt package manager
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y build-essential git libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support automake libtool
sudo apt-get install -y pkg-config libssl-dev unzip
sudo apt-get install -y default-jdk
#-----------------------------
# miniconda
# http://conda.pydata.org/docs/help/silent.html
#-----------------------------
curl -o /home/ubuntu/miniconda.sh "https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh"
bash /home/ubuntu/miniconda.sh -b -p $HOME/miniconda
tee /home/ubuntu/.profile <<EOL
PATH="$HOME/miniconda/bin:$PATH"
EOL
source /home/ubuntu/.profile
rm miniconda.sh
# configure miniconda
conda update -y conda
conda config --set always_yes True
#-----------------------------
# awscli
# http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
#-----------------------------
# configure a conda environment for using awscli...
# ...and create a YAML file that describes this environment.
tee /home/ubuntu/conda_env_awscli.yml <<EOL
# run: conda env create -f conda_env_awscli.yml
# run: conda env update -f conda_env_awscli.yml
# run: conda env remove -n awscli
name: awscli
# in order of priority: lowest (top) to highest (bottom)
channels:
  - conda-forge
  - anaconda
dependencies:
  - python=2
  - fabric
  - pip
  - pip:
    - awscli
EOL
conda env create -f conda_env_awscli.yml
# create the directory that stores AWS credentials
mkdir /home/ubuntu/.aws
#-----------------------------
# Distributed-CellProfiler
#-----------------------------
# configure a conda environment for using Distributed CellProfiler...
# ...and create a YAML file that describes this environment.
tee /home/ubuntu/conda_env_distributed_cellprofiler.yml <<EOL
# run: conda env create -f conda_env_distributed_cellprofiler.yml
# run: conda env update -f conda_env_distributed_cellprofiler.yml
# run: conda env remove -n distributed_cellprofiler
name: distributed_cellprofiler
# in order of priority: lowest (top) to highest (bottom)
channels:
  - conda-forge
  - anaconda
dependencies:
  - python=2
  - boto
  - boto3
  - fabric
  - pandas
  - pip
  - pip:
    - awscli
EOL
conda env create -f conda_env_distributed_cellprofiler.yml
#-----------------------------
# Cell Painting
#-----------------------------
# configure a conda environment for using Cell Painting scripts with python 2.7...
# ...and create a YAML file that describes this environment.
tee /home/ubuntu/conda_env_cellpainting_python_2.yml <<EOL
# run: conda env create -f conda_env_cellpainting_python_2.yml
# run: conda env update -f conda_env_cellpainting_python_2.yml
# run: conda env remove -n cellpainting_python_2
name: cellpainting_python_2
# in order of priority: lowest (top) to highest (bottom)
channels:
  - conda-forge
  - anaconda
dependencies:
  - python=2
  - csvkit
  - ipython
  - jq
  - pip
  - pyyaml
  - pip:
    - awscli
EOL
conda env create -f conda_env_cellpainting_python_2.yml
# configure a conda environment for using Cell Painting scripts with python 3.5...
# ...and create a YAML file that describes this environment.
tee /home/ubuntu/conda_env_cellpainting_python_3.yml <<EOL
# run: conda env create -f conda_env_cellpainting_python_3.yml
# run: conda env update -f conda_env_cellpainting_python_3.yml
# run: conda env remove -n cellpainting_python_3
name: cellpainting_python_3
# in order of priority: lowest (top) to highest (bottom)
channels:
  - conda-forge
  - anaconda
dependencies:
  - python=3
  - csvkit
  - ipython
  - jq
  - pip
  - pyyaml
  - pip:
    - awscli
EOL
conda env create -f conda_env_cellpainting_python_3.yml
#-----------------------------
# linux tools
#-----------------------------
# parallel can run python scripts in parallel
sudo apt-get install -y parallel
#-----------------------------
# docker
# https://docs.docker.com/engine/installation/linux/ubuntulinux/
#-----------------------------
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update -y
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get update -y
sudo apt-get install -y docker-engine
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo service docker start
#sudo docker run hello-world #is sudo necessary?
#-----------------------------
# EFS
# http://docs.aws.amazon.com/efs/latest/ug/wt1-test.html#wt1-mount-fs-and-test
#-----------------------------
# The EFS needs to be mounted anew each time an instance is created.
# http://docs.aws.amazon.com/efs/latest/ug/mount-fs-auto-mount-onreboot.html
#sudo apt-get install -y nfs-common
#mkdir /home/ubuntu/efs
# Mounting the efs from AWS requires sudo. However, this also makes root the owner.
# Change the permissions of the efs.
#sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).fs-3609f37f.efs.us-east-1.amazonaws.com:/ ~/efs
#sudo chown ubuntu:ubuntu ~/efs #or sudo chmod go+rw ~/efs
# Add mounting instructions to the fstab file.
#-----------------------------
# R
# https://www.continuum.io/conda-for-r
# https://www.digitalocean.com/community/tutorials/how-to-install-r-on-ubuntu-16-04-2
#-----------------------------
#-----------------------------
# cytominer
# R: R.home(component = "home")
# R will be installed at "/home/ubuntu/miniconda/envs/cytominer/envs/cytominer/lib/R"
#-----------------------------
# https://github.com/hadley/devtools/issues/379
sudo ln -s /bin/tar /bin/gtar
#
tee /home/ubuntu/conda_env_cytominer.yml <<EOL
# run: conda env create -f conda_env_cytominer.yml
# run: conda env update -f conda_env_cytominer.yml
# run: conda env remove -n cytominer
name: cytominer
# in order of priority: lowest (top) to highest (bottom)
channels:
  - r
  - conda-forge
  - anaconda
dependencies:
  - python=3
  - ipython
  - pip
  - pyyaml
  - r
  - r-devtools
  - r-dplyr
  - r-essentials
  - r-feather
  - r-ggplot2
  - r-knitr
  - r-magrittr
  - r-readr
  - r-rmarkdown
  - r-rsqlite
  - r-stringr
  - r-testthat
  - r-tidyr
  - pip:
    - awscli
    - "--editable=git+https://github.com/0x00b1/persistence.git@master#egg=persistence"
EOL
conda env create -f conda_env_cytominer.yml
source activate cytominer
# R: path.expand("~")
tee /home/ubuntu/.Rprofile <<EOL
options(unzip = 'internal')
EOL
Rscript -e 'install.packages(c("stringi"), repos=c("http://cran.us.r-project.org", "https://cran.cnr.berkeley.edu/", "https://cran.revolutionanalytics.com/"))'
Rscript -e 'devtools::install_github("docopt/docopt.R", dependencies=TRUE)'
Rscript -e 'devtools::install_github("CellProfiler/cytominer", dependencies=TRUE)'
source deactivate cytominer
