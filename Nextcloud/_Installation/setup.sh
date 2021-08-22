#!/bin/bash

#
#This script
#installs Nextcloud
#sets some conf.php variables
#disables the recommended app and rich workspace
#installs a bunch of apps
#sets Collabora URL in Nextcloud
#sets up file previews
#adds cronjobs for previews and NC updates
#

#root permissions until EOF
sudo -s << EOF

echo "*****************************"
echo "*                           *"
echo "*   Installing Nextcloud!   *"
echo "*                           *"
echo "*****************************"
echo "This will take a fiew minutes"
echo "..."
echo ""
docker-compose -f ../docker-compose.yml build --pull -q
docker-compose -f ../docker-compose.yml up -d --quiet-pull

#get path of script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

echo ""
echo "Waiting for Nextcloud to finish installation process"
echo "..."
touch occ.txt
while ! grep "Not enough arguments" occ.txt;do docker exec --user www-data nextcloud_app ./occ app:enable &>> occ.txt;sleep 2 ;done
rm occ.txt

echo "Setting Nextcloud variables"
sed -i 's!);!!' ../Container-Data/html/config/config.php
cat data/add_config.php >> ../Container-Data/html/config/config.php

echo ""
echo "*****************************"
echo "*                           *"
echo "*  Nextcloud is installed!  *"
echo "*                           *"
echo "*****************************"
echo ""
#I don't like the recommended app... nor the rich workspace
docker exec --user www-data nextcloud_app ./occ app:disable recommendations
docker exec --user www-data nextcloud_app ./occ config:app:set text workspace_available --value=0

echo ""
echo "*****************************"
echo "* Installing Nextcloud Apps *"
echo "*****************************"

#(Just add # before any app you don't want! They are in alphabetic order of the original app names.)
docker exec --user www-data nextcloud_app ./occ app:enable approval
docker exec --user www-data nextcloud_app ./occ app:enable auto_groups
docker exec --user www-data nextcloud_app ./occ app:enable breezedark
docker exec --user www-data nextcloud_app ./occ app:enable camerarawpreviews
docker exec --user www-data nextcloud_app ./occ app:enable richdocuments
docker exec --user www-data nextcloud_app ./occ app:enable cospend
docker exec --user www-data nextcloud_app ./occ app:enable external
docker exec --user www-data nextcloud_app ./occ app:enable files_external
docker exec --user www-data nextcloud_app ./occ app:enable extract
docker exec --user www-data nextcloud_app ./occ app:enable impersonate
docker exec --user www-data nextcloud_app ./occ app:enable issuetemplate
docker exec --user www-data nextcloud_app ./occ app:enable files_markdown
docker exec --user www-data nextcloud_app ./occ app:enable metadata
docker exec --user www-data nextcloud_app ./occ app:enable previewgenerator
docker exec --user www-data nextcloud_app ./occ app:enable registration
docker exec --user www-data nextcloud_app ./occ app:enable files_snapshots
docker exec --user www-data nextcloud_app ./occ app:enable unsplash
docker exec --user www-data nextcloud_app ./occ app:enable tasks
docker exec --user www-data nextcloud_app ./occ app:enable video_converter

echo ""
echo "Setting Collabora URL in Nextcloud"
docker exec --user www-data nextcloud_app ./occ config:app:set richdocuments wopi_url --value="https://$(echo $(cat ../docker-compose.yml | grep "traefik.http.routers.collabora.rule=Host") | cut -d'`' -f 2)/"

echo ""
echo "Now let's begin generating file previews!"
docker exec --user www-data nextcloud_app ./occ --quiet preview:generate-all -vvv

echo ""
echo "Adding cronjobs to keep generating previews and update Nextcloud weekly"
#write out current crontab
crontab -l > mycron
#add new crontabs into cron file
cat data/nextcloud_cron >> mycron
#set correct path
sed -i 's!/YOURPATH!'${PWD::-14}'!' mycron
#install new cron file
crontab mycron
rm mycron

#make update.sh executeable
chmod +x ../update.sh

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "*                 Congratulations!                  *"
echo "*    Netcloud is now ready and waiting for you.     *"
echo "*                                                   *"
echo "*****************************************************"

EOF
exit
