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
		
		// ログイン情報をセッションに格納
		$ses->set(SESSION_SESSIONID_KEY, session_id());
		$user = $req->get('user');
		$ses->set(SESSION_USERNAME_KEY, $user);
		$ses->set(SESSION_IP_KEY, $_SERVER['REMOTE_ADDR']);
		$ses->set(SESSION_STATE_KEY, STATE_NOTROLLED);
		$score = new ScoreTable();
		$ses->set(SESSION_SCORE_KEY, $score);
		$ses->set(SESSION_TURN_KEY, 0);
		$dice = new Dice();
		$ses->set(SESSION_DICE_KEY, $dice);

		// クッキーに保存
		if ($req->get('saveUser')) {
			setcookie('user', $user, time() + 60*60*24*30);
		}

		return PAGE_SUCCESS;
	}

	/** セッションは不要 */
	function requireSession() {
		return false;
	}
}
?>
