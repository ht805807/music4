<?php
declare(strict_types=1);

function encryptedApiRequested(): bool {
    return ($_SERVER['HTTP_X_API_ENCRYPTED'] ?? '') === '1';
}

function apiEncryptionKey(): string {
    static $key = null;
    if ($key !== null) return $key;
    $encoded = getenv('API_AES_KEY_B64');
    $decoded = is_string($encoded) ? base64_decode($encoded, true) : false;
    if ($decoded === false || strlen($decoded) !== 32) {
        throw new RuntimeException('Server encryption key is not configured');
    }
    return $key = $decoded;
}

function decryptApiPayload(string $raw): array {
    if (!encryptedApiRequested()) throw new InvalidArgumentException('Encrypted API required');
    $envelope = json_decode($raw, true, 512, JSON_THROW_ON_ERROR);
    if (!is_array($envelope) || ($envelope['v'] ?? null) !== 1) {
        throw new InvalidArgumentException('Invalid encrypted payload');
    }
    $iv = base64_decode((string)($envelope['iv'] ?? ''), true);
    $ciphertext = base64_decode((string)($envelope['ciphertext'] ?? ''), true);
    $tag = base64_decode((string)($envelope['tag'] ?? ''), true);
    if ($iv === false || strlen($iv) !== 12 || $ciphertext === false ||
        $tag === false || strlen($tag) !== 16) {
        throw new InvalidArgumentException('Invalid encrypted payload');
    }
    $cleartext = openssl_decrypt($ciphertext, 'aes-256-gcm', apiEncryptionKey(),
        OPENSSL_RAW_DATA, $iv, $tag);
    if ($cleartext === false) throw new InvalidArgumentException('Invalid encrypted payload');
    $payload = json_decode($cleartext, true, 512, JSON_THROW_ON_ERROR);
    if (!is_array($payload)) throw new InvalidArgumentException('Invalid encrypted payload');
    return $payload;
}

function encryptApiPayload(array $payload): string {
    $iv = random_bytes(12);
    $tag = '';
    $ciphertext = openssl_encrypt(json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR),
        'aes-256-gcm', apiEncryptionKey(), OPENSSL_RAW_DATA, $iv, $tag);
    if ($ciphertext === false) throw new RuntimeException('Could not encrypt response');
    return json_encode(['v' => 1, 'iv' => base64_encode($iv),
        'ciphertext' => base64_encode($ciphertext), 'tag' => base64_encode($tag)],
        JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
}
