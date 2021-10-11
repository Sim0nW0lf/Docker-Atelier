# [Traefik](https://github.com/traefik/traefik)

Traefik is a powerful apache proxy. It works dynamically so you don't have to redirect anything manually.
Lables make it possible for Traefik to find and configure the docker apps.
For those interested have a look at this [quick start guide](https://doc.traefik.io/traefik/getting-started/quick-start/).

This instsallation will give you a SSL Labs A+ rating.
I followed [this tutorial](https://goneuland.de/traefik-v2-reverse-proxy-fuer-docker-unter-debian-10-einrichten/) and scripted everything for a more easy installation.
![image](https://user-images.githubusercontent.com/31454341/130650582-156c26ec-a3df-4509-87e1-2ce8e91b9130.png)
![image](https://user-images.githubusercontent.com/31454341/130647630-ec598a55-07a6-43ca-a6e6-3f75ace61c40.png)

## Prerequisites

* Traefik URL pointing to your server (something like traefik.serverdomain.com)
* Port 80 & 443 opened

## Installation

Run the setup script!
```
chmod +x setup.sh && ./setup.sh
```
