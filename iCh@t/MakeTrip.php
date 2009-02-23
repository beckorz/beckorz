<?php
/**
 * トリップ生成
 *
 * @param $key トリップ生成キー
 *
 * @return トリップ文字列
 */
function makeTrip($key) {
	if ($key == '') {
		return '';
	}
	$key = mb_convert_encoding($key, 'SJIS', 'auto');
	$salt = substr($key . 'H.', 1, 2);
	$salt = preg_replace('/[\x00-\x20\x7B-\xFF]/', '.', $salt);
	$salt = strtr($salt, ':;<=>?@[\]^_`', 'ABCDEFGabcdef');
	$trip = crypt($key, $salt);
	$trip = substr($trip, -10);
	return $trip;
}
?>
