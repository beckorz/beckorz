<?php
/**
 * 共通入力値検証クラス。
 * 各入力値検証クラスはこのクラスを継承します。
 */
class Validator {
	var $request = null;
	var $session = null;
	var $response = null;
	var $errors = array();

	/** コンストラクタ */
	function Validator(&$request, &$session, &$response) {
		$this->request =& $request;
		$this->session =& $session;
		$this->response =& $response;
	}

	/**
	 * 入力値を検証して結果を返す疑似抽象メソッド。
	 * サブクラスでオーバーライドします。
	 * 
	 * @return エラー配列
	 */
	function validate() {
		return $this->errors;
	}
}
?>
