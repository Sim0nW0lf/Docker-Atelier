#!/bin/bash

#get path of script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

echo "******************************"
echo "*                            *"
echo "*     Installing Traefik!    *"
echo "*                            *"
echo "******************************"
echo ""
echo "Installing htpasswd to generate a password"
echo ""
sudo apt-get -qq update
sudo apt-get -qq upgrade -y
sudo apt-get -qq install apache2-utils -y

#creating acme.json
touch ../Container-Data/data/acme.json
chmod 600 ../Container-Data/data/acme.json

echo ""
echo "******************************"
echo "*  Let's configure Traefik!  *"
echo "******************************"

echo ""
echo "Enter your Traefik domain. (Something like traefik.serverdomain.com)"
read domain
sed -i 's/\(.*traefik.rule=Host(`\)[^ ]* \(.*\)/\1'${domain}'`)" \2/g' ../docker-compose.yml
sed -i 's/\(.*secure.rule=Host(`\)[^ ]* \(.*\)/\1'${domain}'`)" \2/g' ../docker-compose.yml

echo ""
echo "Enter you E-Mail here:"
read email
sed -i 's/\(.*email: \)[^ ]* \(.*\)/\1'${email}' \2/g' ../Container-Data/data/traefik.yml

#
#Generate User:Password
#
echo ""
echo "Enter your Traefik webinterface username:"
read user
echo ""
echo "Enter your Traefik webinterface password:"
read password
traefik_credentials=$(echo $(sudo htpasswd -nb $user $password) | sed -e s/\\$/\\$\\$/g)
sed -i 's/\(.*basicauth.users=\)[^ ]* \(.*\)/\1'${traefik_credentials}'" \2/g' ../docker-compose.yml

docker network create proxy

echo ""
echo "Launching Traefik now"
echo ""
sudo docker-compose -f "../docker-compose.yml" up -d --quiet-pull

echo ""
echo "*****************************************************"
echo "*                                                   *"
echo "*                 Congratulations!                  *"
echo "*            Traefik is now installed.              *"
echo "*                                                   *"
echo "*****************************************************"

echo ""
echo "Please note that the web interface will need some time to be accessible!"
echo ""
