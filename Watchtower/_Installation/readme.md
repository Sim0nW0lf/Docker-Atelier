# [Watchtower](https://github.com/containrrr/watchtower)

Watchtower is a nice app that updates your docker containers. E-Mail notifications make it easy to keep track of the updates.
You can easily control when and which containers you want to update.
[Documentation](https://containrrr.dev/watchtower/)

Watchtower is not able to build apps (as far as I know). That is why I exclude [apps that need to be built](https://github.com/Sim0nW0lf/Docker-Atelier/blob/c9b4e8f6bc03176662d7b2cfd60ba747711daa0e/Nextcloud/docker-compose.yml#L27-L30).
In my setup scripts I always make sure that these apps will be updated regularely with scripts so you don't have to worry about updates. [Example below](https://github.com/Sim0nW0lf/Docker-Atelier/new/master/Watchtower#update-containers-that-need-to-be-built)

## Prerequisites

If you want email notifications you need to be able to send mails from a SMTP server. With a gmail account you can do that for example.
Enable two factor authentification, generate an app password and use that with your e-mail as username.

## Installation

You can copy the Watchtower folder to the directory you want your instance to be installed.

For the following commands I assume you are in the "_Installation" directory!
* Make setup.sh executable and run setup.sh
```
chmod +x setup.sh && ./setup.sh
```

## Update Containers that need to be built

For these installations it's not necessary to do anything. The setup scripts will take care of updates which Watchtower can't handle already.
Excluding a container is easy, just add a lable to the docker-compose.yml of the app you want to exclude.
```
com.centurylinklabs.watchtower.enable=false
```

### Nextcloud Example
Here is an example for my Nextcloud Installation:
https://github.com/Sim0nW0lf/Docker-Atelier/blob/c9b4e8f6bc03176662d7b2cfd60ba747711daa0e/Nextcloud/docker-compose.yml#L62

My docker containers all will be automatically updated.
To understand whats happening, here is what I do:

Updating apps that need to be built can be easily be done with a little scipt that will be called with crontabs.
Here is a little example from my Nextcloud Installation: https://github.com/Sim0nW0lf/Docker-Atelier/blob/c9b4e8f6bc03176662d7b2cfd60ba747711daa0e/Nextcloud/update.sh

I am adding crontabs from my setup script here: https://github.com/Sim0nW0lf/Docker-Atelier/blob/22058eee66acd3f7995b1754d239f761c15eb350/Nextcloud/_Installation/setup.sh#L174-L186
