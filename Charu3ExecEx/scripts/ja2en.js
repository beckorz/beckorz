/////////////////////////////////////////////////////////////////////////
//	Google�|��API���g�p�����ȈՓ��p�|��X�N���v�g
//		2010/08/24�@�������[
/////////////////////////////////////////////////////////////////////////
var URL = "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&langpair=ja%7Cen&q=";

var httpObj = createXMLHttp();
if (httpObj) {
	while (!WScript.StdIn.AtEndOfStream) {
		var query = WScript.StdIn.ReadLine();
		httpObj.open("GET", URL + encodeURIComponent(query), false);
		httpObj.send(null);
		if (httpObj.status == 200) {
			var json = eval("(" + httpObj.responseText + ")");
			if (json.responseStatus == 200) {
				WScript.StdOut.Write(json.responseData.translatedText);
			} else {
				WScript.StdOut.Wwite(json.responseDetails);
			}
		} else {
			WScript.StdOut.Write("�ʐM�G���[");
		}
	}
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
