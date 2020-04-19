#! /bin/sh

## ===============================================================================
#  The Cron job
#

# exit if a command fails
set -e

PROJECT_ROOT='/intgraphs_server'
APP_ROOT='/intgraphs_server/apps/intgraphs'
DATETIME=`date +%Y_%m_%d-%H_%M_%S`

# Run script to update project data
echo "\n===================================\n--> Update 'intgraphs', @${DATETIME}"
# Git update
# cd ${PROJECT_ROOT}
# git submodule update --recursive --remote

# Run App
cd ${APP_ROOT}
export PATH=/root/anaconda3/bin:$PATH
# conda create -n intgraphs python=3.7 anaconda
# Restart the 'bash'
eval "$(conda shell.bash hook)"
conda activate intgraphs
# 
pip install --upgrade pip
# pip install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org goose3
# pip install goose3 

# 
sh run-pipe.sh

# 
DATETIME=`date +%Y_%m_%d-%H_%M_%S`
echo "\n√√> DONE, @${DATETIME}\n==================================="
