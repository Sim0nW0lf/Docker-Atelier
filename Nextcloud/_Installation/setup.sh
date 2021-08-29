#!/bin/bash

#
#This script
#helps configuring docker-compose easily
#installs Nextcloud
#sets some conf.php variables
#disables the recommended app and rich workspace
#installs a bunch of apps
#sets Collabora URL in Nextcloud
#sets up file previews
#adds cronjobs for previews and NC updates
#

echo "*****************************"
echo "*                           *"
echo "*   Installing Nextcloud!   *"
echo "*                           *"
echo "*****************************"
echo ""

#get path of script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

echo ""
echo "********************************"
echo "*  Let's configure Nextcloud!  *"
echo "********************************"
echo ""

echo ""
echo "Enter your Nextcloud domain. (Something like cloud.serverdomain.com)"
read domain
sed -i 's/\(.*nextcloud-app.rule=Host(`\)[^ ]* \(.*\)/\1'${domain}'`)" \2/g' ../docker-compose.yml
sed -i 's/\(.*nextcloud-app-secure.rule=Host(`\)[^ ]* \(.*\)/\1'${domain}'`)" \2/g' ../docker-compose.yml
sed -i 's/\(.*OVERWRITEHOST=\)[^ ]* \(.*\)/\1'${domain}' \2/g' ../docker-compose.yml
sed -i 's/\(.* domain=\)[^ ]* \(.*\)/\1'${domain}' \2/g' ../docker-compose.yml

echo ""
echo "Nextcloud Admin Username:"
read nc_user
sed -i 's/\(.*NEXTCLOUD_ADMIN_USER=\)[^ ]* \(.*\)/\1'${nc_user}' \2/g' ../docker-compose.yml

echo "Nextcloud Admin Password:"
read nc_passwd
sed -i 's/\(.*NEXTCLOUD_ADMIN_PASSWORD=\)[^ ]* \(.*\)/\1'${nc_passwd}' \2/g' ../docker-compose.yml

echo ""
read -r -p "Do you want to setup your smtp mail to send mails from Nextcloud? (Y/N): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  echo "Your SMTP Host (Something like smtp.gmail.com)"
  read smtp_host
  sed -i 's/\(.*SMTP_HOST=\)[^ ]* \(.*\)/\1'${smtp_host}' \2/g' ../docker-compose.yml
  echo "Your SMTP Mail (Something like examplename@gmail.com)"
  read smtp_mail
  IFS="@" read mail_name mail_domain <<< "${smtp_mail}"
  sed -i 's/\(.*SMTP_NAME=\)[^ ]* \(.*\)/\1'${smtp_mail}' \2/g' ../docker-compose.yml
  sed -i 's/\(.*MAIL_FROM_ADDRESS=\)[^ ]* \(.*\)/\1'${mail_name}' \2/g' ../docker-compose.yml
  sed -i 's/\(.*MAIL_DOMAIN=\)[^ ]* \(.*\)/\1'${mail_domain}' \2/g' ../docker-compose.yml
  echo "Your email password:"
  read smtp_passwd
  sed -i 's/\(.*SMTP_PASSWORD=\)[^ ]* \(.*\)/\1'${smtp_passwd}' \2/g' ../docker-compose.yml
fi

echo ""
echo "Set your NC Data Path! (like: /your/Path, it will be created if it doesn't exist."
read nc_data
sed -i 's!.*:/media/ncdata!      - '${nc_data}':/media/ncdata!' ../docker-compose.yml
mkdir -p "${nc_data}"
chown www-data:www-data -R "${nc_data}"
echo ""
echo "Now let's configure the database. You need to set MYSQL_ROOT_PASSWORD and MYSQL_PASSWORD (for Nextcloud)"
echo "First enter your MYSQL_ROOT_PASSWORD:"
read mysql_root
sed -i 's/\(.*MYSQL_ROOT_PASSWORD=\)[^ ]* \(.*\)/\1'${mysql_root}' \2/g' ../docker-compose.yml
echo "Now enter your MYSQL_PASSWORD:"
read mysql
sed -i 's/\(.*MYSQL_PASSWORD=\)[^ ]* \(.*\)/\1'${mysql}' \2/g' ../docker-compose.yml

echo "Enter your Collabora domain. (Something like collabora.serverdomain.com)"
read coll_domain
sed -i 's/\(.*collabora.rule=Host(`\)[^ ]* \(.*\)/\1'${coll_domain}'`)" \2/g' ../docker-compose.yml
sed -i 's/\(.*collabora-secure.rule=Host(`\)[^ ]* \(.*\)/\1'${coll_domain}'`)" \2/g' ../docker-compose.yml

#add traefik ip to trusted proxies
traefik_ip="$(docker inspect traefik | grep '                  "IPAddress"'  | cut -d'"' -f 4)"
sed -i 's!\(.*TRUSTED_PROXIES=\)[^ ]* \(.*\)!\1'${traefik_ip}'/16 \2!g' ../docker-compose.yml

echo "Setting up Nextcloud now. This will take a fiew minutes"
echo "..."

#install nextcloud
docker-compose -f ../docker-compose.yml build --pull -q
docker-compose -f ../docker-compose.yml up -d --quiet-pull

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
docker exec --user www-data nextcloud_app ./occ app:enable checksum
docker exec --user www-data nextcloud_app ./occ app:enable camerarawpreviews
docker exec --user www-data nextcloud_app ./occ app:enable richdocuments
docker exec --user www-data nextcloud_app ./occ app:enable cospend
docker exec --user www-data nextcloud_app ./occ app:enable electronicsignatures
docker exec --user www-data nextcloud_app ./occ app:enable external
docker exec --user www-data nextcloud_app ./occ app:enable files_external
docker exec --user www-data nextcloud_app ./occ app:enable extract
docker exec --user www-data nextcloud_app ./occ app:enable integration_google
docker exec --user www-data nextcloud_app ./occ app:enable impersonate
docker exec --user www-data nextcloud_app ./occ app:enable issuetemplate
docker exec --user www-data nextcloud_app ./occ app:enable files_markdown
docker exec --user www-data nextcloud_app ./occ app:enable metadata
docker exec --user www-data nextcloud_app ./occ app:enable files_mindmap
docker exec --user www-data nextcloud_app ./occ app:enable previewgenerator
docker exec --user www-data nextcloud_app ./occ app:enable registration
docker exec --user www-data nextcloud_app ./occ app:enable sendent
docker exec --user www-data nextcloud_app ./occ app:enable files_snapshots
docker exec --user www-data nextcloud_app ./occ app:enable sociallogin
docker exec --user www-data nextcloud_app ./occ app:enable unsplash
docker exec --user www-data nextcloud_app ./occ app:enable spreed
docker exec --user www-data nextcloud_app ./occ app:enable tasks
docker exec --user www-data nextcloud_app ./occ app:enable video_converter
docker exec --user www-data nextcloud_app ./occ app:enable files_zip

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

exit
