# [Nextcloud](https://github.com/nextcloud/docker)

You only have to execute [setup.sh](https://github.com/Sim0nW0lf/Docker-Atelier/blob/7cdbfbeec14a4bca7738bd81aca236412a9e7493/Nextcloud/_Installation/setup.sh)

This script will not only configure your installation, install Nextcloud, selected apps and collabora ready to be used.
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
* If you want to receive mails from Nextcloud or use apps like "register" you need a SMTP Mail.

This setup only works if you have Traefik installed.
Be sure to install it from my [Docker-Atelier](https://github.com/Sim0nW0lf/Docker-Atelier) aswell or read this [tutorial](https://goneuland.de/traefik-v2-reverse-proxy-fuer-docker-unter-debian-10-einrichten/) which I used for my Traefik script.

## Installation

For the following commands I assume you are in the _Installation directory!
Check out all files used in the script if you are curious what is happening ;)

* Make setup.sh executable and run setup.sh
```
chmod +x setup.sh
./setup.sh
```

This will take a while, after configuring your installation about 5 minutes.
Be patient and **enjoy your NC Installation!**

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
