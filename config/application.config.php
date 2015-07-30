<?php

use QEngine\Mvc\Application;

$env     = getenv('APPLICATION_ENV') ?: Application::ENV_PRODUCTION;
$modules = file('config/modules.list', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$appName = rtrim(file_get_contents('config/appname.txt'));

if (in_array($env, [Application::ENV_DEVELOPMENT])) {
    $modules[] = 'ZendDeveloperTools';
}

return [
    'modules'                 => $modules,
    'module_listener_options' => [
        'module_paths'      => [
            './module',
            './vendor'
        ],
        'config_glob_paths'         => [
            'config/autoload/{,*.}{global,' . $env . ',local}.php',
        ],
        'config_cache_enabled'      => $env === Application::ENV_PRODUCTION,
        'module_map_cache_enabled'  => $env === Application::ENV_PRODUCTION,
        'config_cache_key'          => $appName,
        'module_map_cache_key'      => $appName,
        'cache_dir'                 => sys_get_temp_dir(),
        'check_dependencies'        => $env !== Application::ENV_PRODUCTION,
    ]
];
