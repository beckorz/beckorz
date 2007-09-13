<?php
/**
 * スコア状態管理クラス
 */
class ScoreTable {
	var $isScored = array();
	var $point = array();
	var $dice = array();
	var $turn = array();

	/** コンストラクタ */
	function ScoreTable() {
		// 全てのスコア状態を初期化
		for ($i = TABLE_ACES; $i < TABLE_MAX; $i++) {
			$this->isScored[$i] = false;
			$this->point[$i] = 0;
			$this->dice[$i] = null;
			if ($i == TABLE_BONUS) {
				// ボーナスは特殊役
				$this->isScored[$i] = true;
			}
			$this->turn[$i] = 0;
		}
	}

	/** 全てのスコアが埋まっているかチェック */
	function isScoredAll() {
		for ($i = TABLE_ACES; $i < TABLE_MAX; $i++) {
			if (!$this->isScored[$i]) return false;
		}
		return true;
	}

	/** 現在の上段役計を取得 */
	function getUpperTotalPoint() {
		$total = 0;
		for ($i = TABLE_ACES; $i <= TABLE_SIXES; $i++) {
			$total += $this->point[$i];
		}
		return $total;
	}

	/** 現在の下段役計を取得 */
	function getLowerTotalPoint() {
		$total = 0;
		for ($i = TABLE_THREEOFAKIND; $i < TABLE_MAX; $i++) {
			$total += $this->point[$i];
		}
		return $total;
	}

	/** ボーナス点を取得 */
	function getBonusPoint() {
		return (63 <= $this->getUpperTotalPoint()) ? 35 : 0;
	}

	/** 現在のトータル点数を取得 */
	function getGrandTotalPoint() {
		return array_sum($this->point);
	}

	/** 役毎のスコア記録状態のgetter/setter */
	function isScored($index) {
		return $this->isScored[$index];
	}
	function setScored($index, $isScored) {
		if (TABLE_ACES <= $index && $index < TABLE_MAX) {
			$this->isScored[$index] = $isScored;
		}
	}

	/** 役毎の点数のgetter/setter */
	function getPoint($index) {
		return $this->point[$index];
	}
	function setPoint($index, $point) {
		if (TABLE_ACES <= $index && $index < TABLE_MAX) {
			$this->point[$index] = $point;
		}
	}

	/** 役毎のサイコロのgetter/setter */
	function getDice($index) {
		return $this->dice[$index];
	}
	function setDice($index, $dice) {
		if (TABLE_ACES <= $index && $index < TABLE_MAX) {
			$this->dice[$index] = $dice;
		}
	}

	/** 役毎の記録順のgetter/setter */
	function getTurn($index) {
		return $this->turn[$index];
	}
	function setTurn($index, $turn) {
		if (TABLE_ACES <= $index && $index < TABLE_MAX) {
			$this->turn[$index] = $turn;
		}
	}
}
