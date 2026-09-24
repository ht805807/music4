CREATE DATABASE IF NOT EXISTS music4 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE music4;

CREATE TABLE players (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(36) NOT NULL,
  player_name VARCHAR(20) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_players_player_id (player_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE leaderboard_scores (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  player_id VARCHAR(36) NOT NULL,
  game_key VARCHAR(50) NOT NULL,
  score INT UNSIGNED NOT NULL,
  app_version VARCHAR(30) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_scores_player_game (player_id, game_key),
  KEY idx_scores_game_score (game_key, score),
  CONSTRAINT fk_scores_player FOREIGN KEY (player_id) REFERENCES players(player_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE games (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  app_name VARCHAR(100) NOT NULL,
  package_name VARCHAR(255) NOT NULL,
  description VARCHAR(500) NOT NULL,
  icon_url VARCHAR(2048) NOT NULL DEFAULT '',
  sort_order INT NOT NULL DEFAULT 0,
  is_enabled TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_games_package_name (package_name),
  KEY idx_games_enabled_order (is_enabled, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE api_rate_limits (
  rate_key CHAR(64) NOT NULL PRIMARY KEY,
  request_count INT UNSIGNED NOT NULL,
  window_started_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add real publisher-controlled values only; do not invent an actual package name.
-- INSERT INTO games (app_name, package_name, description, icon_url, sort_order, is_enabled)
-- VALUES ('答案之書', 'YOUR.REAL.PACKAGE.NAME', '尋找屬於你的答案', 'https://your-cdn.example/icon.png', 1, 1);
