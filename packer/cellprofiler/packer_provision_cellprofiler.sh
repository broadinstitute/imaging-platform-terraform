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
# add common packages such as *unzip*
sudo apt-get update -y

sudo apt-get upgrade -y

sudo apt-get install -y \
  build-essential \
  git \
  libfuse-dev \
  libcurl4-openssl-dev \
  libxml2-dev \
  mime-support \
  automake \
  libtool

sudo apt-get install -y \
  pkg-config \
  libssl-dev \
  unzip

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
# cellprofiler
# https://github.com/CellProfiler/CellProfiler
#-----------------------------

curl -L -o /home/ubuntu/conda_env_cellprofiler.yml https://raw.githubusercontent.com/karhohs/conda-env-4-cellprofiler/master/cellprofiler/ubuntu/environment.yml

conda env create -f conda_env_cellprofiler.yml

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

sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update -y

sudo apt-get install -y docker-ce

sudo groupadd docker

sudo usermod -aG docker $USER

sudo systemctl enable docker

sudo service docker start

#sudo docker run hello-world

#-----------------------------
# cytominer
# R: R.home(component = "home")
# R will be installed at "/home/ubuntu/miniconda/envs/cytominer/envs/cytominer/lib/R"
#-----------------------------
# https://github.com/hadley/devtools/issues/379
sudo ln -s /bin/tar /bin/gtar

curl -L -o /home/ubuntu/conda_env_cytominer.yml https://raw.githubusercontent.com/karhohs/conda-env-4-cellprofiler/master/cytominer/ubuntu/environment.yml

conda env create -f conda_env_cytominer.yml

source activate cytominer

# R: path.expand("~")
tee /home/ubuntu/.Rprofile <<EOL
options(unzip = 'internal')
EOL

Rscript -e 'devtools::install_github("CellProfiler/cytominer", dependencies=TRUE)'

source deactivate cytominer

#-----------------------------
# terraform
# https://www.terraform.io/intro/getting-started/install.html
#-----------------------------

curl -LO https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_linux_amd64.zip

unzip terraform_0.9.8_linux_amd64.zip -d /home/ubuntu/terraform

tee /home/ubuntu/.profile <<EOL
PATH="$HOME/terraform:$PATH"
EOL

source /home/ubuntu/.profile