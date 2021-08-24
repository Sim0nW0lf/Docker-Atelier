# [Nextcloud](https://github.com/nextcloud/docker)

You only have to configure [docker-compose.yml](https://github.com/Sim0nW0lf/Docker-Atelier/blob/7cdbfbeec14a4bca7738bd81aca236412a9e7493/Nextcloud/docker-compose.yml) and execute [setup.sh](https://github.com/Sim0nW0lf/Docker-Atelier/blob/7cdbfbeec14a4bca7738bd81aca236412a9e7493/Nextcloud/_Installation/setup.sh)

This script will not only install Nextcloud, selected apps and collabora ready to be used.
It also schedules cronjobs to your root user to keep Nextcloud updated.
If you want less/other Nextcloud apps to be installed just edit setup.sh accordingly.

I would suggest also to install [Watchtower](https://github.com/Sim0nW0lf/Docker-Atelier/tree/master/Watchtower) to keep Collabora and your other apps updated aswell.

Fresh Nextcloud instance after installation looks like this:
![Nextcloud Login](https://user-images.githubusercontent.com/31454341/130644123-640b51bd-5a0b-4e18-9575-bb4079277b14.jpg)
![Nextcloud Collabora Integration](https://user-images.githubusercontent.com/31454341/130644941-8383294c-7009-4aff-93fa-771ec0cf051e.png)
![Nextcloud Security](https://user-images.githubusercontent.com/31454341/130649437-075a4c08-b80d-4c77-af15-afc3617d913d.png)


## Prerequisites

* [Traefik](https://github.com/Sim0nW0lf/Docker-Atelier/tree/master/2.%20Traefik)
* Nextcloud URL pointing to your server (something like cloud.exampleserver.com)
* Collabora URL pointing to your server (something like collabora.exampleserver.com)

This setup only works if you have Traefik installed.
Be sure to install it from my [Docker-Atelier](https://github.com/Sim0nW0lf/Docker-Atelier) aswell or read this [tutorial](https://goneuland.de/traefik-v2-reverse-proxy-fuer-docker-unter-debian-10-einrichten/) which I used.

## Installation

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

## Immigrating existing Nextcloud Installation

This shows how to immigrate another Nextcloud Docker Installation with MariaDB.
For more complex immigrations like PostgreSQL, or from a native Nextcloud installation just goole it.

* Install Nextcloud just [like explained](https://github.com/Sim0nW0lf/Docker-Atelier/tree/master/Nextcloud/_Installation#installation) but use the same password for your database as the old installation
* Then cd /to/your/new/ncInstallation
```
docker-compose stop
```
* now copy your old files to the new data directory & copy your database files to /Container-Data/db/. That is necessary because these values are unique and connected to the database.
* also replace the values of `'instanceid' =>`, `'secret' =>` and `'passwordsalt' =>`
```
nano Container-Data/html/config/config.php
```
* now start Nextcloud again
```
docker-compose up -d
```
* and scan your files
```
chown www-data:www-data /path/to/your/data -R
docker exec --user www-data nextcloud_app ./occ files:scan --all
```

## Remove Nextcloud

This is how you can delete all files belonging to this Nextcloud installation.
Now you could setup a completely new instance.

**Be careful!** If you delete your Container-Data and your data dir, all files and user Information will be lost.
```
cd /your/docker-nextcloud/directory
docker-compose down
docker image prune -a
rm -r Container-Data
rm -r /your/data/dir
```
