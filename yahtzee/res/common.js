/**
 * ブラウザ判別してイベント登録
 *
 * @param element イベント登録対象エレメント
 * @param eventName イベント名("on"は付けないこと)
 * @param handler イベントハンドラ
 */
function addEventHandler(element, eventName, handler) {
	if (document.all) {
		element.attachEvent("on" + eventName, handler);
	} else {
		element.addEventListener(eventName, handler, false);
	}
}

/**
 * フォームエレメントにフォーカスをセット
 * 
 * @param formName 対象フォーム名
 * @param elementName 対象エレメント名
 * @param isSelect 対象エレメントがテキストボックスの場合、選択状態にするか？
 */
function focusElement(formName, elementName, isSelect) {
	var elm = document.forms[formName].elements[elementName];
	if (elm.type != "hidden" && !elm.disabled) {
		elm.focus();
		if (elm.type == "text" && isSelect) {
			elm.select();
		}
	}
}

// 切替CSSハッシュ定義
var cssHash =  {
	  "default": { "url": "res/default.css", "title": "デフォルト" }
	, "flat": { "url": "res/flat.css", "title": "フラット" }
	, "midnight": { "url": "res/midnight.css", "title": "深夜" }
};

/**
 * CSS切替ボタンを配置してクッキーに保存されているスタイルシートを適用
 */
function addCssLinks() {
	var rootElement = document.getElementById("cssLinks");
	rootElement.innerHTML = "";
	var defaultCss = getCookie("css");
	if (defaultCss == "") defaultCss = cssHash["default"].url;
	var defaultId = "default";
	for (var key in cssHash) {
		var cssObj = cssHash[key];
		var element = document.createElement("span");
		element.id = key;
		element.title = cssObj.title;
		if (defaultCss == cssObj.url) {
			defaultId = key;
			element.innerHTML = "■";
		} else {
			element.innerHTML = "□";
		}
		element.style.cursor = "pointer";
		rootElement.appendChild(element);
		addEventHandler(element, "click", cssButtonOnClick);
	}
	replaceCss(defaultId);
}

/**
 * CSS切替ボタンクリックイベントハンドラ
 */
function cssButtonOnClick(e) {
	var id = (window.event) ? window.event.srcElement.id : e.target.id;
	replaceCss(id);
}

/**
 * CSS切替
 *
 * @param id 切替ID
 */
function replaceCss(id) {
	var cssObj = cssHash[id];
	var element = document.getElementById("changecss");
	if (!element || !element.cloneNode) return false;
	var newNode = element.cloneNode(true);
	newNode.href = cssObj.url;
	element.parentNode.replaceChild(newNode, element);
	setCookie("css", cssObj.url, 30);

	for (var key in cssHash) {
		document.getElementById(key).innerHTML = (key == id) ? "■" : "□";
	}
}

/**
 * クッキー保存
 *
 * @param key 保存するクッキーのキー
 * @param val 保存する値
 * @param expires 有効期限(日数)
 */
function setCookie(key, val, expires) {
	var date = new Date();
	date.setTime(date.getTime() + (expires * 24*60*60*1000));
	document.cookie = key + '=' + encodeURI(val) + "; expires=" + date.toGMTString() + ";";
}

/**
 * クッキー取得
 *
 * @param key 取得するクッキーのキー
 *
 * @return キーが見つからない場合は""
 */
function getCookie(key) {
	key += "=";
	var cookieVal = document.cookie + ";";
	var start = cookieVal.indexOf(key);
	if (start != -1) {
		var end = cookieVal.indexOf(";", start);
		return decodeURI(cookieVal.substring(start + key.length, end));
	}
	return "";
}
