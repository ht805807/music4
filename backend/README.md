# Music4 PHP API

Requirements: PHP 8.1+ with PDO MySQL, MySQL 8.0+ (the leaderboard uses `ROW_NUMBER()`), HTTPS, and a web server that serves `backend/` as the API document root. Keep `config/`, `helpers/`, and `sql/` outside the public document root when possible.

1. Create a database/user, then import `sql/schema.sql` with `mysql -u USER -p < sql/schema.sql`.
2. Set web-server environment variables: `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`. They are deliberately not stored in this repository.
3. Set `display_errors=Off`, log PHP errors server-side, set a small `post_max_size` (for example `8K`), and terminate TLS at HTTPS. Do not enable HTTP or `usesCleartextTraffic` for release apps.
4. Insert publisher-owned entries into `games`; the supplied SQL only contains a commented template so no false package is deployed.

Endpoints below are relative to the Flutter `API_BASE_URL`. The configured endpoint is `https://123.194.96.90/api`; all builds must use HTTPS.

* `GET leaderboard/list.php?game_key=main_game&limit=100` returns public rank, player name, score, and update time.
* `POST scores/submit.php` accepts JSON `{ "player_id":"UUID", "player_name":"小明", "score":8500, "game_key":"main_game", "app_version":"1.0.5" }`. It retains the highest score for each `(player_id, game_key)` and returns `best_score` and `is_new_record`.
* `GET games/list.php` returns enabled games ordered by `sort_order`.

All responses use `{ "success": bool, "message": string, "data": object|null }` with correct HTTP status. The submit endpoint validates JSON/method/content type, UUID, name, score range and game key; uses PDO prepared statements and an IP rate limiter (10 submissions/minute). Client scores are inherently untrusted: `MAX_SCORE` is an initial ceiling. Set it from real game constraints and add server-verifiable signed game sessions if competitive integrity is required.

## Encrypted API deployment

All application payloads use AES-256-GCM. The wire envelope is JSON only for
transport and has this shape: `{ "v": 1, "iv": "base64", "ciphertext":
"base64", "tag": "base64" }`. The IV is 12 random bytes and the tag is 16
bytes. Set the same Base64-encoded, random 32-byte key in both places:

* Web-server environment: `API_AES_KEY_B64`.
* Flutter build: `--dart-define=API_AES_KEY_B64=<key>`.

For example, generate a key on a trusted administrator machine with
`openssl rand -base64 32`. Do not commit it, send it in chat, or treat a
mobile-app embedded symmetric key as a long-term secret. Rotate it when an app
release is compromised. Deploy this `backend/` directory to the API server
before publishing the app; encrypted list endpoints now use POST.

Run Flutter with `flutter run --dart-define=API_BASE_URL=https://your-domain.example/api --dart-define=API_AES_KEY_B64=<key>`; use the same definitions in CI/release builds. Never put database credentials in Flutter.

Quick API test:

```sh
curl 'https://your-domain.example/api/v1/leaderboard/list.php?game_key=main_game&limit=100'
curl -X POST 'https://your-domain.example/api/v1/scores/submit.php' -H 'Content-Type: application/json' --data '{"player_id":"550e8400-e29b-41d4-a716-446655440000","player_name":"玩家A","score":10,"game_key":"main_game","app_version":"1.0.5"}'
```
