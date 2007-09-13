<?php
/**
 * 共通アクションクラス。
 * 各アクションクラスはこのクラスを継承します。
 */
class Action {
	var $request = null;
	var $session = null;
	var $response = null;

	/** コンストラクタ */
	function Action(&$request, &$session, &$response) {
		$this->request =& $request;
		$this->session =& $session;
		$this->response =& $response;
	}

	/**
	 * リクエストを処理してレスポンスをセットする。
	 * セッションチェック等の基本的な処理後、継承先クラスに動作を委譲します。
	 *
	 * @return 処理後に遷移するページID
	 */
	function execute() {
		// セッション(ログイン)チェック
		if ($this->requireSession()) {
			if (!$this->session->get(SESSION_SESSIONID_KEY)) {
				return PAGE_TIMEOUT;
			}
		}
		return $this->doExecute();
	}

	/**
	 * リクエストを処理してレスポンスをセットする疑似抽象メソッド。
	 * サブクラスでオーバーライドします。
	 *
	 * @return 処理後に遷移するページID
	 */
	function doExecute() {
		return PAGE_SUCCESS;
	}

	/**
	 * セッション(ログイン)が必要なページか判断します。
	 * セッションが不要なページではオーバーライドしてください。
	 *
	 * @return ログイン不要ならfalse、必要ならtrue
	 */
	function requireSession() {
		// 基本的にはセッション(ログイン)が必要
		return true;
	}
}
?>
