#! /bin/sh

## ===============================================================================
#  Docker Config - Entrypoint
#

set -e

# ====================
# Set up the Cron job
echo "\n===================================\nSet up CRON job"
# Prep the "cron scheduler"
chmod a+x /intgraphs_server/scripts/job.sh
chmod 0644 /intgraphs_server/scripts/intgraphs-cron
crontab /intgraphs_server/scripts/intgraphs-cron
crontab -l

# Run
# Kill existing if needed
kill -9 $(cat /var/run/crond.pid)
rm -rf /var/run/crond.pid
# cron
service cron stop
service cron start
echo "\nCRON job started..."

# Keep it running
# tail -f /dev/null
