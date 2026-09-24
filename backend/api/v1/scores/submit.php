<?php
declare(strict_types=1);
require_once __DIR__ . '/../../../config/database.php'; require_once __DIR__ . '/../../../helpers/response.php'; require_once __DIR__ . '/../../../helpers/validation.php'; require_once __DIR__ . '/../../../helpers/security.php';
try { method('POST'); $input=jsonBody(); $id=(string)($input['player_id']??''); $name=cleanPlayerName((string)($input['player_name']??'')); $score=$input['score']??null; $key=(string)($input['game_key']??''); $version=substr(trim((string)($input['app_version']??'')),0,30);
  if(!validUuid($id)||$name===null||filter_var($score,FILTER_VALIDATE_INT)===false||(int)$score<0||(int)$score>MAX_SCORE||!validGameKey($key)||$version==='') respond(400,false,'Invalid score data'); $score=(int)$score; $db=database(); rateLimit($db,'score-submit'); $db->beginTransaction();
  $db->prepare('INSERT INTO players (player_id,player_name) VALUES (?,?) ON DUPLICATE KEY UPDATE player_name=VALUES(player_name),updated_at=CURRENT_TIMESTAMP')->execute([$id,$name]);
  $old=$db->prepare('SELECT score FROM leaderboard_scores WHERE player_id=? AND game_key=? FOR UPDATE');$old->execute([$id,$key]);$existing=$old->fetch();$new=!$existing||$score>(int)$existing['score'];
  if($new)$db->prepare('INSERT INTO leaderboard_scores (player_id,game_key,score,app_version) VALUES (?,?,?,?) ON DUPLICATE KEY UPDATE score=VALUES(score),app_version=VALUES(app_version),updated_at=CURRENT_TIMESTAMP')->execute([$id,$key,$score,$version]);
  $db->commit(); respond(200,true,'Score submitted',['best_score'=>$new?$score:(int)$existing['score'],'is_new_record'=>$new]);
} catch (InvalidArgumentException|JsonException $e) { respond(400,false,$e->getMessage()); } catch(Throwable $e) { if(isset($db)&&$db->inTransaction())$db->rollBack(); error_log('score submit: '.$e->getMessage()); respond(500,false,'目前無法提交成績，請稍後再試。'); }
