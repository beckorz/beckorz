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
 */
function focusElement(formName, elementName) {
	var elm = document.forms[formName].elements[elementName];
	if (elm.type != "hidden" && !elm.disabled) {
		elm.focus();
	}
}
