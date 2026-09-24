<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/encryption.php';
function respond(int $status, bool $success, string $message, mixed $data = null): never {
    http_response_code($status); header('Content-Type: application/json; charset=utf-8');
    if (CORS_ORIGIN !== '') header('Access-Control-Allow-Origin: ' . CORS_ORIGIN);
    $payload = ['success' => $success, 'message' => $message, 'data' => $data];
    echo encryptedApiRequested()
        ? encryptApiPayload($payload)
        : json_encode($payload, JSON_UNESCAPED_UNICODE);
    exit;
}
function method(string $expected): void {
    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(204);
        if (CORS_ORIGIN !== '') {
            header('Access-Control-Allow-Origin: ' . CORS_ORIGIN);
            header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
            header('Access-Control-Allow-Headers: Content-Type, Accept, X-API-Encrypted');
        }
        exit;
    }
    if ($_SERVER['REQUEST_METHOD'] !== $expected) respond(405, false, 'Method not allowed');
}
