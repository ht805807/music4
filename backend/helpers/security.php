<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/config.php';
function rateLimit(PDO $db, string $scope): void {
    $ip = substr($_SERVER['REMOTE_ADDR'] ?? 'unknown', 0, 45); $key = hash('sha256', $scope . '|' . $ip); $now = time();
    $db->beginTransaction();
    try { $select=$db->prepare('SELECT request_count, window_started_at FROM api_rate_limits WHERE rate_key = ? FOR UPDATE'); $select->execute([$key]); $row=$select->fetch();
      if (!$row) { $db->prepare('INSERT INTO api_rate_limits (rate_key, request_count, window_started_at) VALUES (?, 1, NOW())')->execute([$key]); }
      elseif (strtotime($row['window_started_at']) + RATE_LIMIT_WINDOW_SECONDS <= $now) { $db->prepare('UPDATE api_rate_limits SET request_count=1, window_started_at=NOW() WHERE rate_key=?')->execute([$key]); }
      elseif ((int)$row['request_count'] >= RATE_LIMIT_MAX_REQUESTS) { $db->rollBack(); respond(429, false, '操作過於頻繁，請稍後再試。'); }
      else { $db->prepare('UPDATE api_rate_limits SET request_count=request_count+1 WHERE rate_key=?')->execute([$key]); } $db->commit();
    } catch (Throwable $e) { if ($db->inTransaction()) $db->rollBack(); throw $e; }
}
