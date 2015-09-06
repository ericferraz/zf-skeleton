#!/usr/bin/env bash

####################### EDIT HERE ########################

APP_NAME="application"
APP_HOSTNAME="application.dev"

LOGPATH="/var/log/$APP_NAME"

HOSTS_FILE="/etc/hosts"

SERVER_CONTAINER_NAME="nginx"
MYSQL_CONTAINER_NAME="mysql"
PHP_CONTAINER_NAME="phpfpm"
##########################################################

is_installed()
{
    command -v $1 >/dev/null 2>&1 || { echo >&2 "This script requires "$1". Aborting."; exit 1; }
}

is_installed docker
is_installed docker-compose
is_installed docker-machine

if [ $(docker-machine ls | grep -c $APP_NAME) -ge 1 ]; then
    echo "Starting VM Machine"
    docker-machine start $APP_NAME || echo "VM Machine already started"
    exit
fi

docker-machine create --driver virtualbox $APP_NAME
eval "$(docker-machine env $APP_NAME)"
IP_ADDRESS="$(docker-machine ip $APP_NAME)"

sed -e 's/APPLICATION_NAME: .*/APPLICATION_NAME: '$APP_NAME'/g' ./docker-compose.yml > ./docker-compose.yml.tmp && mv ./docker-compose.yml.tmp ./docker-compose.yml
sed -e 's/APPLICATION_HOSTNAME: .*/APPLICATION_HOSTNAME: '$APP_HOSTNAME'/g' ./docker-compose.yml > ./docker-compose.yml.tmp && mv ./docker-compose.yml.tmp ./docker-compose.yml
sed -e 's|- .*:/var/www/html|- '\"$(pwd)':/var/www/html|g' ./docker-compose.yml > ./docker-compose.yml.tmp && mv ./docker-compose.yml.tmp ./docker-compose.yml

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR && docker-compose up -d


SERVER_CONTAINER=$(docker-compose ps -q "$SERVER_CONTAINER_NAME")

echo "Creating log directory"

PHP_CONTAINER=$(docker-compose ps -q "$PHP_CONTAINER_NAME")

docker exec $PHP_CONTAINER mkdir -p $LOGPATH
docker exec $PHP_CONTAINER touch $LOGPATH/general.log
docker exec $PHP_CONTAINER chmod -R 0777 $LOGPATH

MYSQL_CONTAINER=$(docker-compose ps -q "$MYSQL_CONTAINER_NAME")

SQL_FILES=$(ls ./data/db | grep .*.sql);

for SQL_FILE in $SQL_FILES
do
    docker exec -i $MYSQL_CONTAINER mysql -uroot -ppassword application < ./data/db/$SQL_FILE
done

# Check to see if the host is already in the file
HOSTS_REGEX=$IP_ADDRESS[[:space:]]*$APP_HOSTNAME

if grep "$HOSTS_REGEX" $HOSTS_FILE > /dev/null
then
    echo "The host $APP_HOSTNAME is already in the hosts file."; echo;
else
    sudo sh -c "echo "$IP_ADDRESS$'\t'$APP_HOSTNAME" >> $HOSTS_FILE"
    echo "Entry added to hosts file"
fi

echo "Server is running: http://"$APP_HOSTNAME
