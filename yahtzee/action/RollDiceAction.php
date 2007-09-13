<?php
require_once('Action.php');

/**
 * サイコロを振り直す処理のアクションクラス
 */
class RollDiceAction extends Action {
	/** コンストラクタ */
	function RollDiceAction(&$req, &$ses, &$res) {
		parent::Action($req, $ses, $res);
	}

	/** リクエストを処理してレスポンスをセット */
	function doExecute() {
		$req =& $this->request;
		$ses =& $this->session;
		$dice =& $ses->get(SESSION_DICE_KEY);

		// 状態遷移
		$state = STATE_NOTROLLED;
		switch ($ses->get(SESSION_STATE_KEY)) {
			case STATE_NOTROLLED:
				$state = STATE_FIRST;
				break;
			case STATE_FIRST;
				$state = STATE_SECOND;
				break;
			default:
				return PAGE_SUCCESS;
				break;
		}
		$ses->set(SESSION_STATE_KEY, $state);

		// 指定されたサイコロを振り直す
		for ($i = 0; $i < 5; $i++) {
			if ($req->get('chkDie'.$i)) {
				$dice->roll($i);
			}
		}

		return PAGE_SUCCESS;
	}
}
