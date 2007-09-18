<?php
/**
 * コントローラークラス。
 * リクエストパラメータに応じて処理の振り分けを行います。
 */
class Controller {
	var $request = null;
	var $session = null;
	var $response = null;
	var $page = '';

	/** コンストラクタ */
	function Controller($request, $session, $response) {
		$this->request =& $request;
		$this->session =& $session;
		$this->response =& $response;
	}

	/**
	 * リクエストパラメータ毎の処理に振り分けます。
	 * 必要ページ分追加します。
	 * 検証が必要なページでは$validatorに検証用オブジェクトを代入し、
	 * 遷移ページとしてPAGE_SUCCESSとPAGE_FAILUREを必ず設定します。
	 */
	function execute() {
		$req =& $this->request;
		$ses =& $this->session;
		$res =& $this->response;
		$action = null;
		$validator = null;
		$pages = array();
		$pages[PAGE_TIMEOUT] = 'view/Timeout.php';
		switch ($this->request->get('action')) {
			case 'Login':
				// ログイン
				require_once('validator/LoginValidator.php');
				$validator = new LoginValidator($req, $ses, $res);
				require_once('action/LoginAction.php');
				$action = new LoginAction($req, $ses, $res);
				$pages[PAGE_SUCCESS] = 'view/MainPage.php';
				$pages[PAGE_FAILURE] = 'view/TopPage.php';
				break;
			case 'RollDice':
				// サイコロを振り直す
				require_once('action/RollDiceAction.php');
				$action = new RollDiceAction($req, $ses, $res);
				$pages[PAGE_SUCCESS] = 'view/RollDice.php';
				break;
			case 'CheckHand':
				// 役の成立判定
				require_once('action/CheckHandAction.php');
				$action = new CheckHandAction($req, $ses, $res);
				$pages[PAGE_SUCCESS] = 'view/CheckHand.php';
				break;
			case 'RecordScore':
				// スコアを記録
				require_once('action/RecordScoreAction.php');
				$action = new RecordScoreAction($req, $ses, $res);
				$pages[PAGE_SUCCESS] = 'view/RecordScore.php';
				break;
			case 'RegisterRanking':
				// ランキング登録＆状態リセット
				require_once('action/RegisterRankingAction.php');
				$action = new RegisterRankingAction($req, $ses, $res);
				$pages[PAGE_SUCCESS] = 'view/RegisterRanking.php';
				$pages[PAGE_FAILURE] = 'view/TopPage.php';
				break;
			case 'ShowRanking':
				// ランキング表示
				require_once('action/ShowRankingAction.php');
				$action = new ShowRankingAction($req, $ses, $res);
				$pages[PAGE_SUCCESS] = 'view/ShowRanking.php';
				$pages[PAGE_FAILURE] = 'view/TopPage.php';
				break;
			case 'Rss':
				// ランキングRSS出力
				require_once('action/ShowRssAction.php');
				$action = new ShowRssAction($req, $ses, $res);
				$pages[PAGE_SUCCESS] = 'view/ShowRss.php';
				$pages[PAGE_FAILURE] = 'view/ShowRss.php';
				break;
			default:
				// トップページ
				$this->page = 'view/TopPage.php';
				break;
		}
		// 入力検証
		$errors = (!empty($validator)) ? $validator->validate() : null;
		// アクション実行
		if (count($errors) == 0) {
			if (!empty($action)) {
				$this->page = $pages[$action->execute()];
			}
		} else {
			$error_msg = '<div class="attention"><ul>';
			foreach ($errors as $error) {
				$error_msg .= '<li>'.htmlspecialchars($error).'</li>';
			}
			$error_msg .= '</ul></div>';
			$this->response->set(ERROR_MSG, $error_msg);
			$this->page = $pages[PAGE_FAILURE];
		}
		// 結果ページの表示
		$this->showPage();
	}

	/** ページの表示 */
	function showPage() {
		if ($this->page) {
			include_once($this->page);
		} else {
			$this->invalidAccess();
		}
	}

	/** 不正なアクセス、あるいはページ定義がされていない場合の処理 */
	function invalidAccess() {
		include_once(PAGE_ERROR);
		exit;
	}
}
?>
