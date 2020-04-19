#! /bin/sh

## ===============================================================================
#  Init
#   - Install dependency packages
# 

# exit if a command fails
set -e

# General update
apt-get update

# Install `cron`
apt-get install -y --no-install-recommends cron

# cleanup
rm -rf /var/cache/apk/*
