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
PIPELINENAME="gcampillumination.cppipe"
PIPELINE="../../pipelines/${PIPELINENAME}"
INPUTDIR="/home/ubuntu/${PROJECT}/pipelines"
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
echo 'clone 2015_09_01_ALS_Therapeutics_WoolfLab_KasperRoet_BCH'
git clone git@github.com:broadinstitute/2015_09_01_ALS_Therapeutics_WoolfLab_KasperRoet_BCH.git

echo 'retrieve images'
source activate awscli
aws logs create-log-group --log-group-name "${DATASET}"
source deactivate awscli

# Setup the project folders
mkdir -p "${PROJECTPATH}"
mkdir -p "${PROJECTPATH}"/workspace
mkdir -p "${PROJECTPATH}"/workspace/analysis
mkdir -p "${PROJECTPATH}"/workspace/filelist
mkdir -p "${PROJECTPATH}"/workspace/github
mkdir -p "${PROJECTPATH}"/workspace/log
mkdir -p "${PROJECTPATH}"/workspace/metadata
mkdir -p "${PROJECTPATH}"/workspace/pipelines
mkdir -p "${PROJECTPATH}"/workspace/software
mkdir -p "${PROJECTPATH}"/workspace/status
mkdir -p /mnt/ebs/tmp


# Create the filelist
mkdir -p "${PROJECTPATH}"/workspace/filelist/"${DATASET}"
find "${IMAGEDIR}" -type f | tee "${PROJECTPATH}"/workspace/filelist/"${DATASET}"/filelist.txt > /dev/null

cp /home/ubuntu/"${PROJECT}"/pipelines/gcampillumination.cppipe "${PROJECTPATH}"/workspace/pipelines/.

source activate cellpainting_python_3
docker run \
    --rm \
    --volume="${PROJECTPATH}"/workspace/metadata:/metadata_dir \
    --volume="${PROJECTPATH}"/workspace/filelist/"${DATASET}":/filelist_dir \
    --volume="${INPUTDIR}":/input_dir \
    --volume="${PROJECTPATH}"/workspace/pipelines:/pipeline_dir \
    --volume=/mnt/ebs/tmp/:/tmp_dir \
    --volume="${PROJECTPATH}"/workspace:"${PROJECTPATH}"/workspace \
    --volume=/mnt/ebs/:/mnt/ebs/ \
    shntnu/cellprofiler:bethac07_stable_fixzernikes \
    -i /input_dir \
    -p /pipeline_dir/"${PIPELINENAME}" \
    "--file-list=/filelist_dir/filelist.txt" \
    -o /metadata_dir \
    -t /tmp_dir
source deactivate cellpainting_python_3


source activate als
cd "/home/ubuntu/${PROJECT}/software"
python als_initialize.py "/home/ubuntu/als.cfg"                      
python als_calculate_global_decay.py "/home/ubuntu/als.cfg"                      
source deactivate als

source activate awscli
aws s3 sync ${PROJECTPATH}/workspace "s3://imaging-platform/projects/2015_09_01_ALS_Therapeutics_WoolfLab_KasperRoet_BCH/test_plate2/workspace"
source deactivate awscli

# tmux new
# source activate awscli
# parallel -j 60 :::: "${PROJECTPATH}/workspace/batchfiles/${DATASET}/human_usmc_batch_20170127/cp_docker_commands.txt"

echo "Illum Complete!"

sudo umount /mnt/ebs

source activate awscli
EBS_ID=$( cat ~/ebs_id.txt )
aws ec2 detach-volume --volume-id "${EBS_ID}"
source deactivate awscli