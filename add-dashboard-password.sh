#!/usr/bin/env bash

# input parameters
username=${1:-john}
password=${2:-verySecretPassword}

# install utils
# apt install apache2-utils

# encode credentials
htpasswd -nb ${username} ${password}

echo Append it to the end of dynamic/traefik-dashboard.yml
