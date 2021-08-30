#!/bin/bash

#
#This script
#installs Watchtower
#adds smtp config if wanted
#

echo "*****************************"
echo "*                           *"
echo "*  Installing Watchtower!   *"
echo "*                           *"
echo "*****************************"

echo ""
read -r -p "Do you want to setup your smtp mail to get notifications about updated containers from Watchtower? (Y/N): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
  echo "Tell Watchtower the name of your server:"
  read server_name
  sed -i 's/\(.*hostname: \)[^#]*#\(.*\)/\1'"${server_name}"'  #\2/g' ../docker-compose.yml
  echo "Your SMTP Host (Something like smtp.gmail.com)"
  read smtp_host
  sed -i 's/\(.*NOTIFICATION_EMAIL_SERVER: \)[^ ]* \(.*\)/\1'${smtp_host}' \2/g' ../docker-compose.yml
  echo "Your SMTP Mail (Something like sendnotifications@gmail.com)"
  read smtp_mail
  sed -i 's/\(.*NOTIFICATION_EMAIL_FROM: \)[^ ]* \(.*\)/\1'${smtp_mail}' \2/g' ../docker-compose.yml
  sed -i 's/\(.*NOTIFICATION_EMAIL_SERVER_USER: \)[^ ]* \(.*\)/\1'${smtp_mail}' \2/g' ../docker-compose.yml
  echo "Your email password:"
  read smtp_passwd
  sed -i 's/\(.*NOTIFICATION_EMAIL_SERVER_PASSWORD: \)[^ ]* \(.*\)/\1'${smtp_passwd}' \2/g' ../docker-compose.yml
  echo "Mail where you want to get notified to. (Something like getnotifications@gmail.com)"
  read notify_mail
  sed -i 's/\(.*NOTIFICATION_EMAIL_TO: \)[^ ]* \(.*\)/\1'${notify_mail}' \2/g' ../docker-compose.yml
else
  #fill all fields with blanks
  sed -i 's/\(.*NOTIFICATION_EMAIL_SERVER: \)[^ ]* \(.*\)/\1 \2/g' ../docker-compose.yml
  sed -i 's/\(.*NOTIFICATION_EMAIL_FROM: \)[^ ]* \(.*\)/\1 \2/g' ../docker-compose.yml
  sed -i 's/\(.*NOTIFICATION_EMAIL_SERVER_USER: \)[^ ]* \(.*\)/\1 \2/g' ../docker-compose.yml
  sed -i 's/\(.*NOTIFICATION_EMAIL_SERVER_PASSWORD: \)[^ ]* \(.*\)/\1 \2/g' ../docker-compose.yml
  sed -i 's/\(.*NOTIFICATION_EMAIL_TO: \)[^ ]* \(.*\)/\1 \2/g' ../docker-compose.yml
fi

#install Watchtower
docker-compose -f ../docker-compose.yml up -d --quiet-pull

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "*                 Congratulations!                  *"
echo "*           Watchtower is now installed!            *"
echo "*                                                   *"
echo "*****************************************************"
