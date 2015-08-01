My Perfect ZF2 Skeleton
=======================

Introduction
------------
This is my own ZF2 skeleton application using the ZF2 MVC layer and module systems. Purpose of this is to provide a starting point of building simple, but also complex and enterprise applications. This skeleton comes with [Phing](https://www.phing.info) build script that can be used in Continous Integration tools like Jenkins or Travis.

### QEngine modules
Below are modules that support building applications in a "professional" way:
* [qengine-base](https://github.com/jakubigla/qengine-base) - very early stage
* [qengine-locale](https://github.com/jakubigla/qengine-locale)

Installation using Composer
---------------------------

The easiest way to create a new ZF2 project is to use [Composer](https://getcomposer.org/). If you don't have it already installed, then please install as per the [documentation](https://getcomposer.org/doc/00-intro.md).


Create your new ZF2 project:

    composer create-project -n -sdev jakubigla/zf2-skeleton path/to/install



### Installation using a tarball with a local Composer

If you don't have composer installed globally then another way to create a new ZF2 project is to download the tarball and install it:

1. Download the [tarball](https://github.com/zendframework/ZendSkeletonApplication/tarball/master), extract it and then install the dependencies with a locally installed Composer:

        cd my/project/dir
        curl -#L https://github.com/zendframework/ZendSkeletonApplication/tarball/master | tar xz --strip-components=1
    

2. Download composer into your proejct directory and install the dependencies:

        curl -s https://getcomposer.org/installer | php
        php composer.phar install

If you don't have access to curl, then install Composer into your project as per the [documentation](https://getcomposer.org/doc/00-intro.md).


Build script
----------------
Tu run build script, first you have to install [Phing](https://www.phing.info). Then in your project root directory run:
```shell
phing 
```

What this script is doing:
* Install composer dependecies
* Check for PHP syntax errors in your source files
* Run unit tests
* Analise project for quality assurance (pdepend, phpmd, phpcpd, phpcs, phpdoc, phploc, phpcb)


Web server setup
----------------

### Docker containers

This skeleton comes with basic [script](docker-compose.yml), that is used by [docker-compose](https://docs.docker.com/compose/), to create a local and powerful development infrastructure. By default there is only one container enabled - [Apache 2.4, PHP 5.6 (FastCGI)](https://hub.docker.com/u/jakubigla/apache-php-dev), however this script comes with two others: [MySQL](https://registry.hub.docker.com/_/mysql/) and [Jenkins](https://registry.hub.docker.com/u/jakubigla/jenkins-php/) containers. 

I assume you are familiar with Docker and have already installed it (and boot2docker for OSX or Windows) together with Docker orchestration tool: docker-compose. Edit [script](docker-compose.yml) file to meet your requirments (don't forget about data volumes). Add valid entry to your ```/etc/hosts``` file (If you're on OSX or Windows, you can retrieve your VM IP by running: ```shell boot2dock ip```) Now you are ready to run:

```shell 
docker-compose up -d
```
If you're interested in my other Docker images visit [https://hub.docker.com/u/jakubigla/](https://hub.docker.com/u/jakubigla/).

### PHP CLI server

The simplest way to get started if you are using PHP 5.4 or above is to start the internal PHP cli-server in the root
directory:

    php -S 0.0.0.0:8080 -t public/ public/index.php

This will start the cli-server on port 8080, and bind it to all network
interfaces.

**Note:** The built-in CLI server is *for development only*.

### Apache setup

To setup apache, setup a virtual host to point to the public/ directory of the
project and you should be ready to go! It should look something like below:

    <VirtualHost *:80>
        ServerName zf2-app.localhost
        DocumentRoot /path/to/zf2-app/public
        <Directory /path/to/zf2-app/public>
            DirectoryIndex index.php
            AllowOverride All
            Order allow,deny
            Allow from all
            <IfModule mod_authz_core.c>
            Require all granted
            </IfModule>
        </Directory>
    </VirtualHost>

### Nginx setup

To setup nginx, open your `/path/to/nginx/nginx.conf` and add an
[include directive](http://nginx.org/en/docs/ngx_core_module.html#include) below
into `http` block if it does not already exist:

    http {
        # ...
        include sites-enabled/*.conf;
    }


Create a virtual host configuration file for your project under `/path/to/nginx/sites-enabled/zf2-app.localhost.conf`
it should look something like below:

    server {
        listen       80;
        server_name  zf2-app.localhost;
        root         /path/to/zf2-app/public;

        location / {
            index index.php;
            try_files $uri $uri/ @php;
        }

        location @php {
            # Pass the PHP requests to FastCGI server (php-fpm) on 127.0.0.1:9000
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_param  SCRIPT_FILENAME /path/to/zf2-app/public/index.php;
            include fastcgi_params;
        }
    }

Restart the nginx, now you should be ready to go!
