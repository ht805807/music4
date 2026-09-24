<?php
declare(strict_types=1);
function validUuid(string $value): bool { return (bool)preg_match('/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i', $value); }
function validGameKey(string $value): bool { return (bool)preg_match('/^[a-z0-9_]{1,50}$/', $value); }
function cleanPlayerName(string $value): ?string { $value = trim($value); if (preg_match('/[<>]/u', $value) || preg_match('/[\x00-\x1F]/u', $value)) return null; $length = mb_strlen($value, 'UTF-8'); return $length >= 2 && $length <= 20 ? $value : null; }
function jsonBody(): array { $type = strtolower(explode(';', $_SERVER['CONTENT_TYPE'] ?? '')[0]); if ($type !== 'application/json') throw new InvalidArgumentException('Content-Type must be application/json'); $raw = file_get_contents('php://input'); if ($raw === false || strlen($raw) > MAX_REQUEST_BYTES) throw new InvalidArgumentException('Invalid request body'); return decryptApiPayload($raw); }
