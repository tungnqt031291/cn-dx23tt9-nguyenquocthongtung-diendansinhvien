<?php

/**
 * Flarum — config.php
 * Diễn Đàn Sinh Viên
 *
 * File này được mount vào container, override config mặc định.
 * Các giá trị nhạy cảm được đọc từ biến môi trường.
 */

return [
    'debug'   => (bool) ($_SERVER['FLARUM_DEBUG'] ?? false),
    'offline' => false,

    'database' => [
        'driver'    => 'mysql',
        'host'      => $_SERVER['DB_HOST'] ?? 'db',
        'port'      => (int) ($_SERVER['DB_PORT'] ?? 3306),
        'database'  => $_SERVER['DB_NAME']     ?? 'flarum_ddsv',
        'username'  => $_SERVER['DB_USER']     ?? 'flarum',
        'password'  => $_SERVER['DB_PASSWORD'] ?? '',
        'charset'   => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'prefix'    => $_SERVER['DB_PREFIX']   ?? 'flarum_',
        'strict'    => false,
        'engine'    => 'InnoDB',
        'options'   => [
            PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
        ],
    ],

    'url' => $_SERVER['FLARUM_BASE_URL'] ?? 'http://localhost',

    'paths' => [
        'api'   => 'api',
        'admin' => 'admin',
    ],

    'headers' => [
        'poweredByHeader' => false,
        'referrerPolicy'  => 'same-origin',
    ],
];
