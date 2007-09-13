<?php
/**
 * ランキング情報のDAOクラス
 */
class RankingDAO {
	/**
	 * 全ランキング情報の配列を取得する
	 *
	 * @return Rankingクラスの配列
	 */
	function getRankings() {
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
	 * 全ランキング情報の配列を保存する。
	 *
	 * @param $rankings 保存するRankingクラスの配列
	 */
	function setRankings($rankings) {
		$data = serialize($rankings);

		// ロック用ファイルオープン
		$lockfp = fopen(RANKING_LOCK_PATH, 'w');
		flock($lockfp, LOCK_EX);

		// ランキングファイルオープン
		$fp = fopen(RANKING_SAVE_PATH, 'w+');
		stream_set_write_buffer($fp, 0);	// バッファリング無効
		flock($fp, LOCK_EX);

		// 書き込み
		rewind($fp);
		ftruncate($fp, 0);
		fwrite($fp, $data);

		// ランキングファイルクローズ
		flock($fp, LOCK_UN);
		fclose($fp);

		// ロック用ファイルクローズ
		flock($lockfp, LOCK_UN);
		fclose($lockfp);
	}
}
