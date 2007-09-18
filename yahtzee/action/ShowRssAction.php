<?php
require_once('Action.php');

/**
 * ランキングRSS出力処理のアクションクラス
 */
class ShowRssAction extends Action {
	/** コンストラクタ */
	function ShowRssAction(&$req, &$ses, &$res) {
		parent::Action($req, $ses, $res);
	}

	/** リクエストを処理してレスポンスをセット */
	function doExecute() {
		$res =& $this->response;
		
		// ランキング情報を取得
		$dao = new RankingDAO();
		$rankings = $dao->getRankings();
		$res->set('rankings', $rankings);
		if (!file_exists(RANKING_SAVE_PATH)) {
			$date = time();
		} else {
			$date = filemtime(RANKING_SAVE_PATH);
		}
		$res->set('pubDate', date('r', $date));

		return PAGE_SUCCESS;
	}

	/** セッションは不要 */
	function requireSession() {
		return false;
	}
}
?>
