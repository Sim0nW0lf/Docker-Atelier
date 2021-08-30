# [Nextcloud](https://github.com/nextcloud/docker)

You only have to execute [setup.sh](https://github.com/Sim0nW0lf/Docker-Atelier/blob/master/Nextcloud/_Installation/setup.sh).
The Complete setup will take ~8min (If Prerequisites are met already)

This script will not only configure your installation, install Nextcloud, selected apps and collabora ready to be used.
It also schedules cronjobs to your root user to keep Nextcloud updated.
If you want less/other Nextcloud apps to be installed just edit setup.sh accordingly.

I would suggest also to install [Watchtower](https://github.com/Sim0nW0lf/Docker-Atelier/tree/master/Watchtower) to keep Collabora and your other apps updated aswell.

<details>
<summary>Nextcloud demo Installation</summary>
  
```
root@instance-20210825:/Docker/Nextcloud/_Installation# chmod +x setup.sh
root@instance-20210825:/Docker/Nextcloud/_Installation# ./setup.sh
*****************************
*                           *
*   Installing Nextcloud!   *
*                           *
*****************************


********************************
*  Let's configure Nextcloud!  *
********************************

Enter your Nextcloud domain. (Something like cloud.serverdomain.com)
cloud.exampleserver.de

Nextcloud Admin Username:
admin
Nextcloud Admin Password:
****************

Do you want to setup your smtp mail to send mails from Nextcloud? (Y/N): y
Your SMTP Host (Something like smtp.gmail.com)
smtp.gmail.com
Your SMTP Mail (Something like examplename@gmail.com)
mymailname@gmail.com
Your email password:
*****************

Set your NC Data Path! (like: /your/Path, it will be created if it doesn't exist.
/media/NC/ncdata

Now let's configure the database. You need to set MYSQL_ROOT_PASSWORD and MYSQL_PASSWORD (for Nextcloud)
First enter your MYSQL_ROOT_PASSWORD:
****************
Now enter your MYSQL_PASSWORD:
***************

Enter your Collabora domain. (Something like collabora.serverdomain.com)
collabora.exampleserver.de

*******************************
*  Setting up Nextcloud now.  *
*******************************
 This will take a fiew minutes
...
Creating network "nextcloud_default" with the default driver
Creating nextcloud_collabora ... done
Creating nextcloud_db        ... done
Creating nextcloud_redis     ... done
Creating nextcloud_app       ... done

Waiting for Nextcloud to finish installation process
...
Setting Nextcloud variables

*****************************
*                           *
*  Nextcloud is installed!  *
*                           *
*****************************

recommendations 1.1.0 disabled
Config value workspace_available for app text set to 0

*****************************
* Installing Nextcloud Apps *
*****************************
approval 1.0.6 enabled
auto_groups 1.3.1 enabled
breezedark 22.0.1 enabled
checksum 1.1.2 enabled
camerarawpreviews 0.7.12 enabled
richdocuments 4.2.2 enabled
cospend 1.3.12 enabled
electronicsignatures 1.6.2 enabled
external 3.9.0 enabled
files_external 1.12.1 enabled
extract 1.3.2 enabled
integration_google 1.0.3 enabled
impersonate 1.9.0 enabled
issuetemplate 0.7.0 enabled
files_markdown 2.3.4 enabled
metadata 0.14.0 enabled
files_mindmap 0.0.25 enabled
previewgenerator 3.1.1 enabled
registration 1.3.0 enabled
sendent 1.2.7 enabled
files_snapshots 1.0.2 enabled
sociallogin 4.8.3 enabled
unsplash 1.2.3 enabled
spreed 12.0.1 enabled
tasks 0.14.1 enabled
video_converter 1.0.2 enabled
files_zip 1.0.0 enabled

Setting Collabora URL in Nextcloud
Config value wopi_url for app richdocuments set to https://collabora.exampleserver.de/

Now let's begin generating file previews!

Adding cronjobs to keep generating previews and update Nextcloud weekly

*****************************************************
*                                                   *
*                 Congratulations!                  *
*    Netcloud is now ready and waiting for you.     *
*                                                   *
*****************************************************
```
  
</details>

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

You can copy the Nextcloud folder to the directory you want your instance to be installed.

For the following commands I assume you are in the "_Installation" directory!
Check out all files used in the script if you are curious what is happening. ;)

* Make setup.sh executable and run setup.sh
```
chmod +x setup.sh
sudo ./setup.sh
```

This will take a while, about 8 minutes. Be patient and **enjoy your NC Installation!**

After Installation the "_Installation" folder can be deleted!

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
crontab -e  #remove all 3 cronjobs for nextcloud. They are commented accordingly.
```
