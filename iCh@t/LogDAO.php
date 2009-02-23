<?
/**
 * ログ情報のDAOクラス
 */
class LogDAO {
	/**
	 * 全部ログ情報の配列を取得する
	 *
	 * @return Logオブジェクトの配列
	 */
	function getLogs() {
		// ログファイル存在チェック
		if (!file_exists(LOG_SAVE_PATH)) return array();

		// ロック用ファイルオープン
		$lockfp = fopen(LOG_LOCK_PATH, 'w');
		flock($lockfp, LOCK_EX);

		// ログファイルオープン
		$fp = fopen(LOG_SAVE_PATH, 'r');
		flock($fp, LOCK_SH);

		// 読込
		$data = '';
		while (!feof($fp)) {
			$data .= fgets($fp);
		}

		// ログファイルクローズ
		flock($fp, LOCK_UN);
		fclose($fp);

		// ロック用ファイルクローズ
		flock($lockfp, LOCK_UN);
		fclose($lockfp);

		return unserialize($data);
	}

	/**
	 * ログに発言を登録する
	 *
	 * @param $log 登録するLogオブジェクト
	 *
	 * @return 発言登録後のLogオブジェクトの配列
	 */
	function addLog($log) {
		// ロック用ファイルオープン
		$lockfp = fopen(LOG_LOCK_PATH, 'w');
		flock($lockfp, LOCK_EX);

		// ログファイルオープン
		$fp = null;
		$logs = array();
		if (!file_exists(LOG_SAVE_PATH)) {
			$fp = fopen(LOG_SAVE_PATH, 'w');
			flock($fp, LOCK_EX);
		} else {
			$fp = fopen(LOG_SAVE_PATH, 'r+');
			flock($fp, LOCK_EX);

			// 読込
			$data = '';
			while (!feof($fp)) {
				$data .= fgets($fp);
			}
			$logs = unserialize($data);
		}

		// 発言登録
		array_push($logs, $log);
		$logs = array_slice($logs, -LOG_MAX);

		// 書込
		rewind($fp);
		ftruncate($fp, 0);
		fwrite($fp, serialize($logs));

		// ログファイルクローズ
		flock($fp, LOCK_UN);
		fclose($fp);

		// ロック用ファイルクローズ
		flock($lockfp, LOCK_UN);
		fclose($lockfp);

		return $logs;
	}
}
?>
