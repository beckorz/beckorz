<?php
require_once('Validator.php');

/**
 * ログイン処理の入力値検証クラス
 */
class LoginValidator extends Validator {
	/** コンストラクタ */
	function LoginValidator(&$req, &$ses, &$res) {
		parent::Validator($req, $ses, $res);
	}

	/** 入力値を検証して結果を返す */
	function validate() {
		$req =& $this->request;

		if (trim($req->get('user')) == '') {
			array_push($this->errors, '名前を入力してください。');
		}
		return $this->errors;
	}
}
?>
