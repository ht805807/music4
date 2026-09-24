<?php
declare(strict_types=1);
require_once __DIR__ . '/../../../config/database.php';
require_once __DIR__ . '/../../../helpers/response.php';
require_once __DIR__ . '/../../../helpers/validation.php';

try {
    method('POST');
    jsonBody(); // Validates the encrypted envelope even though this list has no filters.
    $query = database()->query('SELECT app_name, package_name, description, icon_url, sort_order FROM games WHERE is_enabled=1 ORDER BY sort_order ASC, id ASC');
    respond(200, true, 'OK', $query->fetchAll());
} catch (InvalidArgumentException|JsonException $e) {
    respond(400, false, $e->getMessage());
} catch (Throwable $e) {
    error_log('games list: ' . $e->getMessage());
    respond(500, false, 'Unable to retrieve games');
}
