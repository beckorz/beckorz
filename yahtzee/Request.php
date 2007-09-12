<?php
/**
 * リクエスト処理クラス。
 */
class Request {
	var $params = array();
	
	/** コンストラクタ */
	function Request() {
		$http_vars = null;

		if ($_SERVER['REQUEST_METHOD'] == 'GET') {
			$http_vars =& $_GET;
		} else {
			$http_vars =& $_POST;
		}

		if (is_array($http_vars)) {
			foreach ($http_vars as $name => $value) {
				$this->set($name, $value);
			}
		}
	}

	/** リクエスト値を設定 */
	function set($name, $data) {
		$this->params[$name] = $data;
	}

	/** リクエスト値を取得 */
	function get($name) {
		return $this->params[$name];
	}
}
?>
