<?php
/**
 * 定数群の定義
 */
// セッションファイルの保存パス
define('SESSION_SAVE_PATH', './session');
// セッションタイムアウト時間(分単位)
define('SESSION_CACHE_EXPIRE', 30);
// ランキングファイルの保存パス
define('RANKING_SAVE_PATH', './ranking/ranking.dat');
// ランキングファイルのロック用ファイルパス
define('RANKING_LOCK_PATH', './ranking/lock');

// 正常ページ遷移ID
define('PAGE_SUCCESS', 'success');
// 失敗ページ遷移ID
define('PAGE_FAILURE', 'failure');
// タイムアウト遷移ID
define('PAGE_TIMEOUT', 'timeout');
// エラーページファイル
define('PAGE_ERROR', './Error.php');
// エラーメッセージキー
define('ERROR_MSG', 'error_msg');

// ログインユーザーのセッションIDキー
define('SESSION_SESSIONID_KEY', 'session_id');
// ログインユーザーの名前キー
define('SESSION_USERNAME_KEY', 'session_user');
// ログインユーザーのIPアドレスキー
define('SESSION_IP_KEY', 'session_ip');
// ログインユーザーの状態キー
define('SESSION_STATE_KEY', 'session_state');
// ログインユーザーの記録順キー
define('SESSION_TURN_KEY', 'session_turn');
// ログインユーザーのスコア状態キー
define('SESSION_SCORE_KEY', 'session_score');
// ログインユーザーのサイコロ状態キー
define('SESSION_DICE_KEY', 'session_dice');

// ログインユーザーの状態
// サイコロを振っていない
define('STATE_NOTROLLED', 'state_notrolled');
// サイコロ1回目終了
define('STATE_FIRST', 'state_first');
// サイコロ2回目終了
define('STATE_SECOND', 'state_second');
// 全スコア終了
define('STATE_ALLSCORED', 'state_allscored');

// 役のインデックス
define('TABLE_ACES', 0);
define('TABLE_TWOS', 1);
define('TABLE_THREES', 2);
define('TABLE_FOURS', 3);
define('TABLE_FIVES', 4);
define('TABLE_SIXES', 5);
define('TABLE_BONUS', 6);
define('TABLE_THREEOFAKIND', 7);
define('TABLE_FOUROFAKIND', 8);
define('TABLE_FULLHOUSE', 9);
define('TABLE_SMALLSTRAIGHT', 10);
define('TABLE_LARGESTRAIGHT', 11);
define('TABLE_YAHTZEE', 12);
define('TABLE_CHANCE', 13);
define('TABLE_MAX', 14);
?>
