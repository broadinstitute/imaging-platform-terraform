#!/bin/bash
# This *sleep* pauses this shell script so that the EC2 instance has time to initialize.
# 30 seconds is a round number heuristically chosen by the crowd and discovered on stackoverflow posting.
# 
sleep 30

source /home/ubuntu/.profile
# Variables
PROJECT="2015_09_01_ALS_Therapeutics_WoolfLab_KasperRoet_BCH"
PROJECTPATH="/mnt/ebs/myproject/${PROJECT}"
DATASET="test_plate2"
IMAGEDIR="/mnt/ebs/projects/${PROJECT}/${DATASET}/images"
S3DIR="s3://imaging-platform/projects/${PROJECT}/${DATASET}/images/R44821_160612180003"

# mount ebs

sudo mkdir /mnt/ebs

sudo mount /dev/xvdh /mnt/ebs

sudo chown -R ubuntu /mnt/ebs

# add the id_rsa_aws ssh private key to access private GitHub repositories
tee /home/ubuntu/.ssh/config <<EOL
IdentityFile /home/ubuntu/.ssh/id_rsa_aws
EOL
chmod 400 /home/ubuntu/.ssh/id_rsa_aws
eval `ssh-agent -s`
ssh-add /home/ubuntu/.ssh/id_rsa_aws
ssh-keyscan -t rsa github.com > /home/ubuntu/.ssh/known_hosts

# download project scripts
echo "clone ${PROJECT}"
git clone git@github.com:broadinstitute/"${PROJECT}".git

echo 'retrieve images'
source activate awscli
aws logs create-log-group --log-group-name "${PROJECT}_${DATASET}"
source deactivate awscli

# Setup the project folders
mkdir -p "${PROJECTPATH}"
mkdir -p "${PROJECTPATH}"/workspace
mkdir -p "${PROJECTPATH}"/workspace/analysis
mkdir -p "${PROJECTPATH}"/workspace/analysis/image/max_projection
mkdir -p "${PROJECTPATH}"/workspace/filelist
mkdir -p "${PROJECTPATH}"/workspace/github
mkdir -p "${PROJECTPATH}"/workspace/log
mkdir -p "${PROJECTPATH}"/workspace/metadata
mkdir -p "${PROJECTPATH}"/workspace/pipelines
mkdir -p "${PROJECTPATH}"/workspace/software
mkdir -p "${PROJECTPATH}"/workspace/status

# prep for max_projection

source activate als
bash /home/ubuntu/2015_09_01_ALS_Therapeutics_WoolfLab_KasperRoet_BCH/software/als_parallel_maxproj.sh -g /home/ubuntu/als.cfg -j 63
source deactivate als

echo "Max Projection Complete!"

sudo umount /mnt/ebs

source activate awscli
EBS_ID=$( cat ~/ebs_id.txt )
aws ec2 detach-volume --volume-id "${EBS_ID}"
source deactivate awscli

#source activate awscli
#aws s3 sync "${PROJECTPATH}"/workspace "s3://imaging-platform/projects/${PROJECT}/workspace"
#source deactivate awscli

# tmux new
# source activate awscli
# aws logs create-log-group --log-group-name "${PROJECT}_${DATASET}"
# parallel -j 60 :::: "${PROJECTPATH}/workspace/batchfiles/${DATASET}/analysis_bethac07_radial_entropy_batch/cp_docker_commands.txt"