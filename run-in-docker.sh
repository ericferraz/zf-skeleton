#!/usr/bin/env bash

set -e

####################### EDIT HERE ########################

# don't forget to change values in docker-compose.yml too
# as currently this script doesn't touch that file
APP_HOSTNAME="application.dev"
APP_NAME="application"
LOGPATH="/var/log/$APP_NAME"
IP_ADDRESS="127.0.0.1"
HOSTS_FILE="/etc/hosts"
CONTAINER_NAME="apachephp"
##########################################################

is_installed()
{
    command -v $1 >/dev/null 2>&1 || { echo >&2 "This script requires "$1". Aborting."; exit 1; }
}

is_installed docker
is_installed docker-compose

if [[ "$OSTYPE" == "darwin"* ]]; then
    is_installed boot2docker
    #boot2docker up
    IP_ADDRESS="$(boot2docker ip)"
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#cd $DIR && docker-compose up -d

echo "Creating log directory"
CONTAINER=$(docker-compose ps -q "$CONTAINER_NAME")

docker exec $CONTAINER mkdir -p $LOGPATH
docker exec $CONTAINER chmod 0777 $LOGPATH

# Check to see if the host is already in the file
HOSTS_REGEX=$IP_ADDRESS[[:space:]]*$APP_HOSTNAME

if grep "$HOSTS_REGEX" $HOSTS_FILE > /dev/null
then
    echo "The host $APP_HOSTNAME is already in the hosts file."; echo;
else
#
#    sudo -s <<EOF
#        echo -e "$IP_ADDRESS\t$APP_HOSTNAME" >> $HOSTS_FILE
#    EOF
    echo "Entry added to hosts file"
fi

echo "Server is running: http://"$APP_HOSTNAME
echo "Docker ID: $CONTAINER"