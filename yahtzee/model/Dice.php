<?php
/**
 * サイコロ管理クラス
 */
// 各役の正規表現(ソート済みの目を対象)
define('RE_ACES', '/(1+)/');
define('RE_TWOS', '/(2+)/');
define('RE_THREES', '/(3+)/');
define('RE_FOURS', '/(4+)/');
define('RE_FIVES', '/(5+)/');
define('RE_SIXES', '/(6+)/');
define('RE_THREEOFAKIND', '/([1-6])\1{2}/');
define('RE_FOUROFAKIND', '/([1-6])\1{3}/');
define('RE_FULLHOUSE', '/(([1-6])\2([1-6])\3{2}|([1-6])\4{2}([1-6])\5)/');
define('RE_SMALLSTRAIGHT', '/(1+2+3+4+|2+3+4+5+|3+4+5+6+)/');
define('RE_LARGESTRAIGHT', '/^1?23456?$/');
define('RE_YAHTZEE', '/^([1-6])\1{4}$/');

class Dice {
	var $dice = array();

	/** コンストラクタ */
	function Dice() {
		$this->rollAll();
	}

	/**
	 * 現在のサイコロの配列を返す
	 *
	 * @return サイコロ配列
	 */
	function getDice() {
		return $this->dice;
	}

	/**
	 * 各サイコロの目を返す
	 *
	 * @param $index インデックス(0〜5)
	 */
	function getDie($index) {
		return $this->dice[$index];
	}

	/**
	 * 全てのサイコロをふる
	 */
	function rollAll() {
		for ($i = 0; $i < 5; $i++) {
			$this->dice[$i] = mt_rand(1, 6);
		}
	}
	/**
	 * サイコロをふる
	 *
	 * @param $index インデックス(0〜5)
	 */
	function roll($index) {
		$this->dice[$index] = mt_rand(1, 6);
	}

	/**
	 * 各サイコロの目を連結して返す
	 *
	 * @return 連結した文字列
	 */
	function toString() {
		return join('', $this->dice);
	}

	/**
	 * 各サイコロの目をソート後に連結して返す
	 *
	 * @return 連結した文字列
	 */
	function toSortedString() {
		$work = array_values($this->dice);
		sort($work);
		return join('', $work);
	}

	/**
	 * 点数を取得
	 *
	 * @param $index 役のインデックス
	 *
	 * @return 役が成立していればその点数、成立していなければ0を返す
	 */
	function getPoint($index) {
		switch ($index) {
			case TABLE_ACES:
				return $this->isAces();
			case TABLE_TWOS:
				return $this->isTwos();
			case TABLE_THREES:
				return $this->isThrees();
			case TABLE_FOURS:
				return $this->isFours();
			case TABLE_FIVES:
				return $this->isFives();
			case TABLE_SIXES:
				return $this->isSixes();
			case TABLE_THREEOFAKIND:
				return $this->isThreeOfAKind();
			case TABLE_FOUROFAKIND:
				return $this->isFourOfAKind();
			case TABLE_FULLHOUSE:
				return $this->isFullHouse();
			case TABLE_SMALLSTRAIGHT:
				return $this->isSmallStraight();
			case TABLE_LARGESTRAIGHT:
				return $this->isLargeStraight();
			case TABLE_YAHTZEE:
				return $this->isYahtzee();
			case TABLE_CHANCE:
				return $this->isChance();
			default:
				return 0;
		}
	}

	/**
	 * エース成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isAces() {
		preg_match(RE_ACES, $this->toSortedString(), $match);
		return ($match) ? strlen($match[1]) : 0;
	}

	/**
	 * ツー成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isTwos() {
		preg_match(RE_TWOS, $this->toSortedString(), $match);
		return ($match) ? strlen($match[1]) * 2 : 0;
	}

	/**
	 * スリー成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isThrees() {
		preg_match(RE_THREES, $this->toSortedString(), $match);
		return ($match) ? strlen($match[1]) * 3 : 0;
	}

	/**
	 * フォー成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isFours() {
		preg_match(RE_FOURS, $this->toSortedString(), $match);
		return ($match) ? strlen($match[1]) * 4 : 0;
	}

	/**
	 * ファイブ成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isFives() {
		preg_match(RE_FIVES, $this->toSortedString(), $match);
		return ($match) ? strlen($match[1]) * 5 : 0;
	}

	/**
	 * シックス成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isSixes() {
		preg_match(RE_SIXES, $this->toSortedString(), $match);
		return ($match) ? strlen($match[1]) * 6 : 0;
	}

	/**
	 * スリーダイス成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isThreeOfAKind() {
		preg_match(RE_THREEOFAKIND, $this->toSortedString(), $match);
		return ($match) ? array_sum($this->dice) : 0;
	}

	/**
	 * フォーダイス成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isFourOfAKind() {
		preg_match(RE_FOUROFAKIND, $this->toSortedString(), $match);
		return ($match) ? array_sum($this->dice) : 0;
	}

	/**
	 * フルハウス成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isFullHouse() {
		preg_match(RE_FULLHOUSE, $this->toSortedString(), $match);
		return ($match) ? 25 : 0;
	}

	/** 
	 * スモールストレート成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isSmallStraight() {
		preg_match(RE_SMALLSTRAIGHT, $this->toSortedString(), $match);
		return ($match) ? 30 : 0;
	}

	/**
	 * ラージストレート成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isLargeStraight() {
		preg_match(RE_LARGESTRAIGHT, $this->toSortedString(), $match);
		return ($match) ? 40 : 0;
	}

	/**
	 * ヤッツィー成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isYahtzee() {
		preg_match(RE_YAHTZEE, $this->toSortedString(), $match);
		return ($match) ? 50 : 0;
	}

	/**
	 * チャンス成立チェック
	 *
	 * @return 成立していれば点数、成立していなければ0を返す
	 */
	function isChance() {
		// 常に成立する
		return array_sum($this->dice);
	}

}
