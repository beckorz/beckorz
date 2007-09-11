<?php
require_once('Action.php');

/**
 * ログイン処理のアクションクラス
 */
class LoginAction extends Action {
	/** コンストラクタ */
	function LoginAction(&$req, &$ses, &$res) {
		parent::Action($req, $ses, $res);
	}

	/** リクエストを処理してレスポンスをセット */
	function doExecute() {
		$req =& $this->request;
		$ses =& $this->session;
		$res =& $this->response;
		
		// ログイン情報をセッションに格納
		$ses->set(SESSION_SESSIONID_KEY, session_id());
		$ses->set(SESSION_USERNAME_KEY, $req->get('user'));
		$ses->set(SESSION_IP_KEY, $_SERVER['REMOTE_ADDR']);
		$ses->set(SESSION_STATE_KEY, STATE_NOTROLLED);
		$ses->set(SESSION_DICES_KEY, 123456);

		return PAGE_SUCCESS;
	}

	/** セッションは不要 */
	function requireSession() {
		return false;
	}
}
?>
