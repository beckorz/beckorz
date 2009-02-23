<?php
/**
 * 定数群の定義
 */
// HN省略時のデフォルト
define('HN_DEFAULT', '名無したん');
// セッションファイルの保存パス
define('SESSION_SAVE_PATH', './session');
// セッションタイムアウト時間(分単位)
define('SESSSION_CACHE_EXPIRE', 1);
// ログファイルの保存パス
define('LOG_SAVE_PATH', './log/log.dat');
// ログファイルのロック用ファイルパス
define('LOG_LOCK_PATH', './log/lock');
// ログ保持件数
define('LOG_MAX', 20);
// 発言文字数最大長
define('MSG_MAXLENGTH', 500);

// ログインユーザーのセッションIDキー
define('SESSION_ID_KEY', 'session_id');
// ログインユーザーの名前キー
define('SESSION_HN_KEY', 'session_hn');
// ログインユーザーのトリップキー
define('SESSION_TRIP_KEY', 'session_trip');
// ログインユーザーのIPアドレスキー
define('SESSION_IP_KEY', 'session_ip');
?>
