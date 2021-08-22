#!/bin/bash

#get path of script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

#update Nextcloud
docker-compose stop
docker-compose build --pull
docker-compose up -d
