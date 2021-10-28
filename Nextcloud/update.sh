#!/bin/bash

#get path of script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

#log latest Update

#Date
{ echo $'\n' ; echo $'Update Date:' ; date ; echo '' ; } > ./update.log
#Nextcloud Update
docker-compose down --rmi all >> ./update.log
docker-compose up -d --build >> ./update.log
