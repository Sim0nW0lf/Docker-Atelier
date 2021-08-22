#!/bin/bash

#get path of script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

echo "*****************************"
echo "*                           *"
echo "*    Installing Traefik!    *"
echo "*                           *"
echo "*****************************"
echo ""
echo "Installing htpasswd to generate a password"
echo ""
sudo apt-get -qq update
sudo apt-get -qq install apache2-utils -y

#creating acme.json
touch ../Container-Data/data/acme.json
chmod 600 ../Container-Data/data/acme.json

#
#Generate User:Password
#
#get user:password string
u=$(cat ../docker-compose.yml | grep '"traefik.http.middlewares.traefik-auth.basicauth.users=')
u="$(grep -oP '(?<=users=).*?(?=")' <<< "$u")"
#we need user:password later, so continue with new variable
p=$u
#replacing : with a space
p=${p/:/ }

echo "Generating htpasswd from user:password credentials"
echo ""
p=$(echo $(sudo htpasswd -nb $p) | sed -e s/\\$/\\$\\$/g)

echo "Replacing user:password in docker-compose.yml"
echo ""
sed -i "s,$u,$p," ../docker-compose.yml

#create proxy network
docker network create proxy

echo "Launching Traefik now"
echo ""
sudo docker-compose -f "../docker-compose.yml" up -d

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "*                 Congratulations!                  *"
echo "*            Traefik is now installed.              *"
echo "*                                                   *"
echo "* PLEASE WAIT A MINUTE                              *"
echo "* for traefik to make the web interface accessible  *"
echo "*                                                   *"
echo "*****************************************************"
