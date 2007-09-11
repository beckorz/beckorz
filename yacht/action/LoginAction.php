<?php
require_once('Action.php');
require_once('model/Score.php');
require_once('model/Dice.php');

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
		$score = new Score();
		$ses->set(SESSION_SCORE_KEY, $score);
		$dice = new Dice();
		$ses->set(SESSION_DICE_KEY, $dice);

		return PAGE_SUCCESS;
	}

	/** セッションは不要 */
	function requireSession() {
		return false;
	}
}
?>
