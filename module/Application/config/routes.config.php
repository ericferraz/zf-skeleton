<?php

namespace Application;

use Application\Controller\IndexController;
use Zend\Mvc\Router\Http\Literal;

return [
    'home' => [
        'type' => Literal::class,
        'options' => [
            'route'    => '/',
            'defaults' => [
                'controller' => IndexController::class,
                'action'     => 'index',
            ],
        ],
    ],
];
