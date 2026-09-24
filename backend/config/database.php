<?php
declare(strict_types=1);
require_once __DIR__ . '/config.php';
function database(): PDO {
    static $pdo = null;
    if ($pdo instanceof PDO) return $pdo;
    $host = getenv('DB_HOST'); $name = getenv('DB_NAME'); $user = getenv('DB_USER'); $pass = getenv('DB_PASSWORD');
    if (!$host || !$name || !$user) throw new RuntimeException('Database is not configured.');
    $pdo = new PDO("mysql:host={$host};dbname={$name};charset=utf8mb4", $user, $pass ?: '', [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, PDO::ATTR_EMULATE_PREPARES => false]);
    return $pdo;
}
