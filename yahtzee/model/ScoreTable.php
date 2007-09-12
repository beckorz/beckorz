<?php
/**
 * スコア状態管理クラス
 */
// 役のインデックス
define('TABLE_ACES', 0);
define('TABLE_TWOS', 1);
define('TABLE_THREES', 2);
define('TABLE_FOURS', 3);
define('TABLE_FIVES', 4);
define('TABLE_SIXES', 5);
define('TABLE_BONUS', 6);
define('TABLE_THREEOFAKIND', 7);
define('TABLE_FOUROFAKIND', 8);
define('TABLE_FULLHOUSE', 9);
define('TABLE_SMALLSTRAIGHT', 10);
define('TABLE_LARGESTRAIGHT', 11);
define('TABLE_YAHTZEE', 12);
define('TABLE_CHANCE', 13);
define('TABLE_MAX', 14);

class ScoreTable {
	var $isScored = array();
	var $point = array();
	var $dice = array();

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

}
