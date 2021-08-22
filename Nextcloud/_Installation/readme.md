# Installing Nextcloud

You only have to configure docker-compose.yml, create a data folder owned by www-data and execute setup.sh

This script will not only install Nextcloud, selected apps and collabora ready to be used.
It also schedules cronjobs to your root user to keep Nextcloud updated.
If you want less/other apps to be installed just edit setup.sh accordingly.

## Prerequisites

* Traefik
* Nextcloud URL pointing to your server
* Collabora URL pointing to your server

This setup only works if you have Traefik installed.
Be sure to install it from my Docker-Atelier aswell or read this tutorial which I used.
https://goneuland.de/traefik-v2-reverse-proxy-fuer-docker-unter-debian-10-einrichten/

If you already have Traefik installed then you probably need to change "wg" to make Traefik env variables work.

## Install Nextcloud

For the following commands I assume you are in the _Installation directory!
Check out all files used in the script if you are curious what is happening ;)

* Open docker-compose.yml and change all values marked with # behind it! ctl+s to save, ctl+x to close
```
nano ../docker-compose.yml
```

* Make setup.sh executable
```
chmod +x setup.sh
```

* run setup.sh
```
./setup.sh
```

This will take a while, about 5 minutes.
Be patient and **enjoy your NC Installation!**

## Remove Nextcloud

This is how you can delete all files belonging to this Nextcloud installation.
Now you could setup a completely new instance.
```
cd /your/docker-nextcloud/directory
docker-compose down
docker image prune -a
rm -r Container-Data
rm -r /your/data/dir
```
