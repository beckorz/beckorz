<?php
require_once('Action.php');

/**
 * スコアを記録する処理のアクションクラス
 */
class RecordScoreAction extends Action {
	/** コンストラクタ */
	function RecordScoreAction(&$req, &$ses, &$res) {
		parent::Action($req, $ses, $res);
	}

	/** リクエストを処理してレスポンスをセット */
	function doExecute() {
		$req =& $this->request;
		$ses =& $this->session;
		$res =& $this->response;
		$score =& $ses->get(SESSION_SCORE_KEY);
		$dice =& $ses->get(SESSION_DICE_KEY);

		$hand = (int)$req->get('hand');
		if (!$score->isScored($hand)) {
			// スコアを記録
			$score->setScored($hand, true);
			$point = $dice->getPoint($hand);
			$res->set('point', $point);
			$score->setPoint($hand, $point);
			$score->setPoint(TABLE_BONUS, $score->getBonusPoint());
			$score->setDice($hand, $dice->getDice());
			$res->set('dice', $dice->getDice());
			$turn = $ses->get(SESSION_TURN_KEY) + 1;
			$score->setTurn($hand, $turn);
			$ses->set(SESSION_TURN_KEY, $turn);

			// 状態遷移
			if (!$score->isScoredAll()) {
				$dice->rollAll();
				$ses->set(SESSION_STATE_KEY, STATE_NOTROLLED);
			} else {
				$ses->set(SESSION_STATE_KEY, STATE_ALLSCORED);
			}
		}

		return PAGE_SUCCESS;
	}
}
