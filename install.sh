#!/usr/bin/env bash

# input parameters
domainname=${1:-traefik.127-0-0-1.nip.io}

# check if swarm mode is active
docker info | grep -i swarm
# ... and if not, activate it
docker swarm init

# create DMZ network
docker network create --driver=overlay dmz

# checkout Traefik basic configuration
git clone linksoftcz@vs-ssh.visualstudio.com:v3/linksoftcz/linksoft-infrastructure/Traefik
cd Traefik
git checkout swarm

# set Traefik hostname
echo sed -i "s/traefik.127-0-0-1.nip.io/${domainname}/g" dynamic/traefik-dashboard.yml

# start Traefik
docker stack deploy -c docker-compose.yml traefik

# if everything is working well, switch Lets Encrypt to production mode
sed -i 's/caServer/# caServer/g' traefik.yml
# ... and restart Traefik resetting Lets Encrypt state
docker stack rm traefik
rm letsencrypt/acme.json
docker stack deploy -c docker-compose.yml traefik
