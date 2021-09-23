#!/bin/bash

#get path of script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

#log updates
{ echo $'\n' ; echo $'Update Date:' ; date ; echo '' ; } >> ./update.log
#update Nextcloud
docker-compose stop >> ./update.log
docker-compose build --pull >> ./update.log
docker-compose up -d >> ./update.log
