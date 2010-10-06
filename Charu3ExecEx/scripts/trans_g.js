/////////////////////////////////////////////////////////////////////////
//	Google�|��API���g�p�����ȈՉp���E���p�|��X�N���v�g
//		2010/09/14�@�������[
/////////////////////////////////////////////////////////////////////////
var DETECTURL = "http://ajax.googleapis.com/ajax/services/language/detect?v=1.0&q=";
var TRANSURL =  "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=";

var httpObj = createXMLHttp();
if (httpObj) {
	var QUERY = WScript.StdIn.ReadAll();
	httpRequest(httpObj, DETECTURL + encodeURIComponent(QUERY), detectSuccess, requestError);
}

function createXMLHttp() {
	var ret = null;
	try {
		ret = new XMLHttpRequest();
	} catch (e) {
		try {
			ret = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				ret = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e) { }
		}
	}
	return ret;
}

function httpRequest(obj, url, onsuccess, onerror) {
	obj.open("GET", url, false);
	obj.send(null);
	if (obj.status == 200) {
		onsuccess(obj);
	} else {
		onerror(obj);
	}
}

function detectSuccess(obj) {
	var json = eval("(" + obj.responseText + ")");
	if (json.responseStatus == 200) {
		// �����������ꔻ�肳�ꂪ���Ȃ̂œ��{��ƌ��Ȃ�
		var langpair = (json.responseData.language.match(/(?:JA|CN)$/i)) ? "ja%7Cen" : "en%7Cja";
		httpRequest(obj, TRANSURL + encodeURIComponent(QUERY) + "&langpair=" + langpair, transSuccess, requestError);
	} else {
		WScript.StdOut.Write(json.responseDetails);
	}
}

function transSuccess(obj) {
	var json = eval("(" + obj.responseText + ")");
	if (json.responseStatus == 200) {
		WScript.StdOut.Write(json.responseData.translatedText);
	} else {
		WScript.StdOut.Write(json.responseDetails);
	}
}

function requestError(obj) {
	WScript.StdOut.Write("�ʐM�G���[");
}
