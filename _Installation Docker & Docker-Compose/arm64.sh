#!/bin/bash

#
#Update
#
apt -qq update
apt -qq upgrade -y

#
#ínstall Docker
#
apt-get -qq install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get -qq update

apt-get -qq install docker-ce docker-ce-cli containerd.io -y

#
#install docker-compose
#
apt -qq install -y python3-pip libffi-dev

yes | pip3 install docker-compose

apt -qq autoremove -y