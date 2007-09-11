<?php
/**
 * スコア状態管理クラス
 */
class Score {
	var $scored = array();
	var $point = array();

	/** コンストラクタ */
	function Score() {
		// 全てのスコア状態を未設定にして点数を0に初期化
		for ($i = 0; $i < 12; $i++) {
			array_push($this->scored, false);
			array_push($this->point, 0);
		}
	}

	/** ヨットのスコア状態と点数のgetter/setter */
	function isScoredYacht() {
		return $this->scored[0];
	}
	function setScoredYacht($scored) {
		$this->scored[0] = $scored;
	}
	function getPointYacht() {
		return $this->point[0];
	}
	function setPointYacht($point) {
		$this->point[0] = $point;
	}
	
	// TODO 以下、他の役のgetter/setter作成
}
