<?php
/**
 * ランキング情報のDAOクラス
 */
class RankingDAO {
	/**
	 * 全ランキング情報の配列を取得する
	 *
	 * @return Rankingオブジェクトの配列
	 */
	function getRankings() {
		// ランキングファイル存在チェック
		if (!file_exists(RANKING_SAVE_PATH)) return array();

		// ロック用ファイルオープン
		$lockfp = fopen(RANKING_LOCK_PATH, 'w');
		flock($lockfp, LOCK_EX);

		// ランキングファイルオープン
		$fp = fopen(RANKING_SAVE_PATH, 'r');
		flock($fp, LOCK_SH);

		// 読み込み
		$data = '';
		while (!feof($fp)) {
			$data .= fgets($fp);
		}

		// ランキングファイルクローズ
		flock($fp, LOCK_UN);
		fclose($fp);

		// ロック用ファイルクローズ
		flock($lockfp, LOCK_UN);
		fclose($lockfp);

		return unserialize($data);
	}

	/**
	 * ランクインチェック
	 *
	 * @param $rankings 既存Rankingオブジェクトの配列
	 * @param $ranking チェックするRankingオブジェクト
	 *
	 * @return ランクインするならtrueを返す
	 */
	function isRankin($rankings, $ranking) {
		if (count($rankings) < RANKING_MAX) {
			return true;
		} else {
			// 最後の要素と比較
			$lowest = array_pop($rankings);
			return (0 <= compare($lowest, $ranking));
		}
	}

	/**
	 * スコアをランキングに登録
	 *
	 * @param $ranking 登録するRankingオブジェクト
	 *
	 * @return ランクインした場合にはtrueを返す
	 */
	function addRanking($ranking) {
		$ret = false;

		// ロック用ファイルオープン
		$lockfp = fopen(RANKING_LOCK_PATH, 'w');
		flock($lockfp, LOCK_EX);

		// 読み込み
		$fp = null;
		$rankings = array();
		if (!file_exists(RANKING_SAVE_PATH)) {
			$fp = fopen(RANKING_SAVE_PATH, 'w');
			flock($fp, LOCK_EX);
		} else {
			$fp = fopen(RANKING_SAVE_PATH, 'r+');
			flock($fp, LOCK_EX);

			$data = '';
			while (!feof($fp)) {
				$data .= fgets($fp);
			}
			$rankings = unserialize($data);
		}

		// ランキング登録
		$ret = $this->isRankin($rankings, $ranking);
		$newRankings = $this->addRankingAndSlice($rankings, $ranking);

		// 書き込み
		rewind($fp);
		ftruncate($fp, 0);
		fwrite($fp, serialize($newRankings));

		// ランキングファイルクローズ
		flock($fp, LOCK_UN);
		fclose($fp);

		// ロック用ファイルクローズ
		flock($lockfp, LOCK_UN);
		fclose($lockfp);

		return $ret;
	}

	/**
	 * ランキング登録＆上位切り出し
	 *
	 * @param $rankings 既存Rankingオブジェクトの配列
	 * @param $ranking 登録するRankingオブジェクト
	 *
	 * @return 結果Rankingオブジェクトの配列
	 */
	function addRankingAndSlice($rankings, $ranking) {
		// ランキング追加
		array_push($rankings, $ranking);

		// 点数降順、登録日降順でソート
		usort($rankings, array($this, 'compare'));

		// 上位切り出し
		return array_slice($rankings, 0, RANKING_MAX);
	}

	/**
	 * ソート用ランキング比較関数。
	 * 点数降順、登録日降順でソートします。
	 */
	function compare($lh, $rh) {
		$pointCompare = 0;
		if ($lh->getPoint() < $rh->getPoint()) $pointCompare = 1;
		if ($rh->getPoint() < $lh->getPoint()) $pointCompare = -1;
		$dateCompare = 0;
		if ($lh->getDate() < $rh->getDate()) $dateCompare = 1;
		if ($rh->getDate() < $lh->getDate()) $dateCompare = -1;

		if ($pointCompare == 0) {
			return $dateCompare;
		} else {
			return $pointCompare;
		}
	}
}
?>
