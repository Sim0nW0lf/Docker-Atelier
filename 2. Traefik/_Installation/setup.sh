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
sed -i "s|$(cat ../docker-compose.yml | grep 'traefik.http.routers.traefik.rule=Host')|      - \"traefik.http.routers.traefik.rule=Host(\`${domain}\`)\"  #your Traefik domain (Something like traefik.serverdomain.com)|" ../docker-compose.yml
sed -i "s|$(cat ../docker-compose.yml | grep 'traefik.http.routers.traefik-secure.rule=Host')|      - \"traefik.http.routers.traefik-secure.rule=Host(\`${domain}\`)\"  #your Traefik domain (Something like traefik.serverdomain.com)|" ../docker-compose.yml

echo ""
echo "Enter you E-Mail here:"
read email
sed -i "s|$(cat ../Container-Data/data/traefik.yml | grep '      email:')|      email: ${email}  ###|" ../Container-Data/data/traefik.yml

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
sed -i "s|$(cat ../docker-compose.yml | grep 'traefik.http.middlewares.traefik-auth.basicauth.users')|      - \"traefik.http.middlewares.traefik-auth.basicauth.users=${traefik_credentials}\"  #USER:PASSWORD (Password generated with htpasswd. See here: https://mindup.medium.com/add-basic-authentication-in-docker-compose-files-with-traefik-34c781234970)|" ../docker-compose.yml

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
