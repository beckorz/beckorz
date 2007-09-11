<?php
/**
 * 定数群の定義
 */
// セッションファイルの保存パス
define('SESSION_SAVE_PATH', './session');
// セッションタイムアウト時間(分単位)
define('SESSION_CACHE_EXPIRE', 30);
// ランキングファイルの保存パス
define('RANKING_SAVE_PATH', './score');

// 正常ページ遷移ID
define('PAGE_SUCCESS', 'success');
// 失敗ページ遷移ID
define('PAGE_FAILURE', 'failure');
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
// ログインユーザーのダイス目キー
define('SESSION_DICES_KEY', 'session_dices');

// ログインユーザーの状態
// ダイスを振っていない
define('STATE_NOTROLLED', 'state_notrolled');
// ダイス1回目終了
define('STATE_FIRST', 'state_first');
// ダイス2回目終了
define('STATE_SECOND', 'state_second');
// 全スコア終了
define('STATE_ALLSCORED', 'state_allscored');
?>
