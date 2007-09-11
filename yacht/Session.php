<?php
/**
 * セッション管理クラス。
 */
class Session {
	/** セッション値を設定 */
	function set($name, $data) {
		$_SESSION[$name] = $data;
	}

	/** セッション値を取得 */
	function get($name) {
		return $_SESSION[$name];
	}

	/** セッションを破棄 */
	function destroy() {
		$_SESSION = array();
		session_destroy();
	}
}

// セッションを開始する
session_save_path(SESSION_SAVE_PATH);
session_cache_expire(SESSION_CACHE_EXPIRE);
session_start();
?>
