# Installing Nextcloud

You only have to configure docker-compose.yml and execute setup.sh

## Prerequisites

This setup only works if you have Traefik installed.
Be sure to install it from my Docker-Artelier aswell or read this tutorial which I used to make traefik env variables work.
https://goneuland.de/traefik-v2-reverse-proxy-fuer-docker-unter-debian-10-einrichten/

For the following commands I assume you are in the _Installation directory!
Check out all files used in the script if you are curious ;)

## Installation

Open docker-compose.yml and change all values marked with # behind it! ctl+s to save, ctl+x to close
```
nano ../docker-compose.yml
```

Make setup.sh executable
```
chmod +x setup.sh
```

run setup.sh
```
./setup.sh
```

This will take a while, about 5 minutes.
Be patient and **enjoy your NC Installation!**
