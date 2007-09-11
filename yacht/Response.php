<?php
/**
 * レスポンス処理クラス。
 */
class Response {
	var $data = array();

	/** レスポンス値を設定 */
	function set($name, $data) {
		$this->data[$name] = $data;
	}

	/** レスポンス値を取得 */
	function get($name) {
		return $this->data[$name];
	}
}
?>
