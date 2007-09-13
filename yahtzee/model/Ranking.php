<?php
/**
 * ランキングを表現するクラス
 */
class Ranking {
	var $user = "";
	var $point = 0;
	var $date = 0;
	var $dice = array();
	var $turn = array();

	/** コンストラクタ */
	function Ranking() {}

	/** 名前のgetter/setter */
	function getUser() {
		return $this->user;
	}
	function setUser($user) {
		$this->user = $user;
	}

	/** トータル点数のgetter/setter */
	function getPoint() {
		return $this->point;
	}
	function setPoint($point) {
		$this->point = $point;
	}

	/** 登録日時のgetter/setter */
	function getDate() {
		return $this->date;
	}
	function setDate($date) {
		$this->date = $date;
	}

	/** 各役の出目構成のgetter/setter */
	function getDice() {
		return $this->dice;
	}
	function setDice($dice) {
		$this->dice = $dice;
	}

	/** 各役の記録順のgetter/setter */
	function getTurn() {
		return $this->turn;
	}
	function setTurn($turn) {
		$this->turn = $turn;
	}
}
