<?php

use Zend\Mvc\Application;

chdir(realpath(__DIR__) . '/..');

include './vendor/autoload.php';

Application::init(include './config/application.config.php');
