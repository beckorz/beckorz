<?php
require_once('Action.php');

/**
 * ランキング表示処理のアクションクラス
 */
class ShowRankingAction extends Action {
	/** コンストラクタ */
	function ShowRankingAction(&$req, &$ses, &$res) {
		parent::Action($req, $ses, $res);
	}

	/** リクエストを処理してレスポンスをセット */
	function doExecute() {
		$res =& $this->response;
		
		// ランキング情報を取得
		$dao = new RankingDAO();
		$rankings = $dao->getRankings();
		$res->set('rankings', $rankings);

		return PAGE_SUCCESS;
	}

	/** セッションは不要 */
	function requireSession() {
		return false;
	}
}
?>
