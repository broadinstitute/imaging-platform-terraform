#!/bin/bash
# This *sleep* pauses this shell script so that the EC2 instance has time to initialize.
# 30 seconds is a round number heuristically chosen by the crowd and discovered on stackoverflow posting.
# 
sleep 30

source /home/ubuntu/.profile
# Variables
PROJECT="2015_09_01_ALS_Therapeutics_WoolfLab_KasperRoet_BCH"
PROJECTPATH="/home/ubuntu/myproject/${PROJECT}"
DATASET="test_plate2"
IMAGEDIR="/home/ubuntu/bucket/projects/${PROJECT}/${DATASET}/images"
PIPELINENAME="gcampillumination.cppipe"
PIPELINE="../../pipelines/${PIPELINENAME}"
INPUTDIR="/home/ubuntu/${PROJECT}/pipelines"
S3DIR="s3://imaging-platform/projects/${PROJECT}/${DATASET}/images/R44821_160612180003"

echo 'retrieve images'
source activate awscli
aws s3 cp --recursive "${S3DIR}" "${IMAGEDIR}" 
source deactivate awscli

shutdown