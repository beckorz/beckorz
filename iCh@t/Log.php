<?
/**
 * ログを表現するクラス
 */
class Log {
	var $user = '';
	var $trip = '';
	var $msg = '';
	var $date = 0;

	/** コンストラクタ */
	function Log($user, $trip, $msg) {
		$this->user = $user;
		$this->trip = $trip;
		$this->msg = $msg;
		$this->date = time();
	}

	/** 名前のgetter/setter */
	function getUser() {
		return $this->user;
	}
	function setUser($user) {
		$this->user = $user;
	}

	/** トリップのgetter/setter */
	function getTrip() {
		return $this->trip;
	}
	function setTrip($trip) {
		$this->trip = $trip;
	}

	/** 発言内容のgetter/setter */
	function getMsg() {
		return $this->msg;
	}
	function setMsg($msg) {
		$this->msg = $msg;
	}

	/** 発言日時のgetter/setter */
	function getDate() {
		return $this->date;
	}
	function setDate($date) {
		$this->date = $date;
	}
}
?>
