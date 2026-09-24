<?php
declare(strict_types=1);
require_once __DIR__ . '/../../../config/database.php';
require_once __DIR__ . '/../../../helpers/response.php';
require_once __DIR__ . '/../../../helpers/validation.php';

try {
    method('POST');
    $input = jsonBody();
    $key = (string)($input['game_key'] ?? '');
    if (!validGameKey($key)) respond(400, false, 'Invalid game_key');
    $limit = min(100, max(1, (int)($input['limit'] ?? 100)));
    $sql = 'SELECT ROW_NUMBER() OVER (ORDER BY s.score DESC, s.created_at ASC) AS `rank`, p.player_name, s.score, DATE_FORMAT(s.updated_at, "%Y-%m-%d %H:%i:%s") AS updated_at FROM leaderboard_scores s INNER JOIN players p ON p.player_id=s.player_id WHERE s.game_key=? ORDER BY s.score DESC, s.created_at ASC LIMIT ?';
    $query = database()->prepare($sql);
    $query->bindValue(1, $key, PDO::PARAM_STR);
    $query->bindValue(2, $limit, PDO::PARAM_INT);
    $query->execute();
    respond(200, true, 'OK', $query->fetchAll());
} catch (InvalidArgumentException|JsonException $e) {
    respond(400, false, $e->getMessage());
} catch (Throwable $e) {
    error_log('leaderboard list: ' . $e->getMessage());
    respond(500, false, 'Unable to retrieve leaderboard');
}
