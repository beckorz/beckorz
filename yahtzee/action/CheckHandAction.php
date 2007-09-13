<?php
require_once('Action.php');

/**
 * 役の成立判定処理のアクションクラス
 */
class CheckHandAction extends Action {
	/** コンストラクタ */
	function CheckHandAction(&$req, &$ses, &$res) {
		parent::Action($req, $ses, $res);
	}

	/** リクエストを処理してレスポンスをセット */
	function doExecute() {
		$req =& $this->request;
		$ses =& $this->session;
		$res =& $this->response;
		$dice =& $ses->get(SESSION_DICE_KEY);

		$hand = (int)$req->get('hand');
		$res->set('point', $dice->getPoint($hand));

		return PAGE_SUCCESS;
	}
}
