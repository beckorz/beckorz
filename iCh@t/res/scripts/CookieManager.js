/**
 * クッキー操作クラス
 */
CookieManager = Class.create();
CookieManager.prototype = {
	/** コンストラクタ */
	initialize: function () { }

	/**
	 * クッキー保存
	 *
	 * @param key 保存するクッキーのキー
	 * @param val 保存する値
	 * @param expires 有効期限(日数)
	 */
	, set: function (key, val, expires) {
		var date = new Date();
		date.setTime(date.getTime() + (expires * 24*60*60*1000));
		document.cookie = key + '=' + encodeURI(val) + '; expires=' + date.toGMTString() + ';';
	}

	/**
	 * クッキー取得
	 *
	 * @param key 取得するクッキーのキー
	 *
	 * @return キーが見つからない場合はnull
	 */
	, get: function (key) {
		key += '=';
		var cookieVal = document.cookie + ";";
		var start = cookieVal.indexOf(key);
		if (start != -1) {
			var end = cookieVal.indexOf(';', start);
			return decodeURI(cookieVal.substring(start + key.length, end));
		}
		return null;
	}
}
