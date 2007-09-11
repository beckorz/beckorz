<?php
/**
 * サイコロ管理クラス
 */
class Dice {
	var $dice = array();

	/** コンストラクタ */
	function Dice() {
		// 5個のサイコロの目を乱数で決定
		for ($i = 0; $i < 5; $i++) {
			array_push($this->dice, mt_rand(1, 6));
		}
	}

	/** 各サイコロの目を返す */
	function getDie($index) {
		return $this->dice[$index];
	}

	/** 各サイコロの目を連結して返す */
	function toString() {
		return join('', $this->dice);
	}

	/** ヨットが成立しているかどうかを返す */
	function isYacht() {
		// TODO 判定処理
		return true;
	}

	/** ビッグ・ストレートが成立しているかどうかを返す */
	function isBigStraight() {
		// TODO 判定処理
		return true;
	}

	/** リトル・ストレートが成立しているかどうかを返す */
	function isLittleStraight() {
		// TODO 判定処理
		return true;
	}

	/** フォー・オブ・ア・カインドが成立しているかどうかを返す */
	function isFourOfAKind() {
		// TODO 判定処理
		return true;
	}

	/** フルハウスが成立しているかどうかを返す */
	function isFullHouse() {
		// TODO 判定処理
		return true;
	}

	/** チョイスが成立しているかどうかを返す */
	function isChoise() {
		// 常に成立する
		return true;
	}

	/** シックスが成立しているかどうかを返す */
	function isSix() {
		// TODO 判定処理
		return true;
	}

	/** ファイブが成立しているかどうかを返す */
	function isFive() {
		// TODO 判定処理
		return true;
	}

	/** フォーが成立しているかどうかを返す */
	function isFour() {
		// TODO 判定処理
		return true;
	}

	/** トレイが成立しているかどうかを返す */
	function isTreys() {
		// TODO 判定処理
		return true;
	}

	/** デュースが成立しているかどうかを返す */
	function isDucks() {
		// TODO 判定処理
		return true;
	}

	/** エースが成立しているかどうかを返す */
	function isAce() {
		// TODO 判定処理
		return true;
	}
}
