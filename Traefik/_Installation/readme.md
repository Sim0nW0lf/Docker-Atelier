# Traefik

Traefik is a powerful apache proxy. It works dynamically so you don't have to redirect anything manually.
Lables make it possible for Traefik to find and configure the docker apps.
https://doc.traefik.io/traefik/getting-started/quick-start/

This instsallation will give you a SSL Labs A+ rating.
I followed this tutorial and scripted the password part that had to be done manually.
All credits go to: https://goneuland.de/traefik-v2-reverse-proxy-fuer-docker-unter-debian-10-einrichten/

## Installation

Change the necessary values in the docker-compose.yml
Then run the setup script!
```
chmod +x setup.sh
./setup.sh
```
