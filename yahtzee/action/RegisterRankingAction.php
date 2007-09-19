<?php
require_once('Action.php');

/**
 * ランキング登録＆状態リセット処理のアクションクラス
 */
class RegisterRankingAction extends Action {
	/** コンストラクタ */
	function RegisterRankingAction(&$req, &$ses, &$res) {
		parent::Action($req, $ses, $res);
	}

	/** リクエストを処理してレスポンスをセット */
	function doExecute() {
		$req =& $this->request;
		$ses =& $this->session;
		$res =& $this->response;
		$score =& $ses->get(SESSION_SCORE_KEY);

		if (!$score->isScoredAll()) {
			return PAGE_FAILURE;
		}

		// ランキング登録
		$isRegister = (bool)$req->get('register');
		if ($isRegister) {
			$ranking = new Ranking();
			$ranking->setUser($ses->get(SESSION_USERNAME_KEY));
			$ranking->setPoint($score->getGrandTotalPoint());
			$ranking->setDice($score->getAllDice());
			$ranking->setTurn($score->getAllTurn());
			$comment = mb_substr($req->get('comment'), 0, RANKING_COMMENT_MAXLENGTH, 'utf-8');
			$ranking->setComment($comment);

			$dao = new RankingDAO();
			if ($dao->addRanking($ranking)) {
				$res->set('message', 'ランクインしました♪(｀･ω･´)');
			} else {
				$res->set('message', 'ランクインしなかったようです…(´･ω･｀)');
			}
		}

		// 初期化処理
		$ses->set(SESSION_STATE_KEY, STATE_NOTROLLED);
		$score = new ScoreTable();
		$ses->set(SESSION_SCORE_KEY, $score);
		$ses->set(SESSION_TURN_KEY, 0);
		$dice = new Dice();
		$ses->set(SESSION_DICE_KEY, $dice);

		return PAGE_SUCCESS;
	}
}
?>
