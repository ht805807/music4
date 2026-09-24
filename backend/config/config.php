<?php
declare(strict_types=1);
// Configure these values in the web server environment; never commit production credentials.
const APP_ENV = 'production';
const CORS_ORIGIN = ''; // Empty = no browser CORS header (mobile apps do not need it).
const MAX_REQUEST_BYTES = 4096;
const MAX_SCORE = 1000000;
const RATE_LIMIT_WINDOW_SECONDS = 60;
const RATE_LIMIT_MAX_REQUESTS = 10;
// Set API_AES_KEY_B64 in the web server environment to a Base64-encoded
// 32-byte key. Never commit the key or place it in a public PHP file.
ini_set('display_errors', '0');
error_reporting(E_ALL);
