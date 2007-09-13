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
		$isRegister = (bool)$req->get('register');
		// TODO ランキング登録＆状態リセット処理を記述
		if ($isRegister) {
			RankingDAO::setRankings($score);
			$res->set('message', 'ランキング登録したぉ(　＾ω＾)' . $req->get('comment'));
			$res->set('result', 1);
		} else {
			$res->set('message', 'ランキング登録しなかったぉ(´･ω･｀)' . $req->get('comment'));
			$sc = RankingDAO::getRankings();
			$res->set('message', $sc->getGrandTotalPoint());
			$res->set('result', 0);
		}
		//$res->set('result', true);

		return PAGE_SUCCESS;
	}
}
?>
