/////////////////////////////////////////////////////////////////////////
//	Yahoo Pipes�|��API���g�p�����ȈՉp���|��X�N���v�g
//		2010/08/24�@�������[
/////////////////////////////////////////////////////////////////////////
var URL = "http://pipes.yahoo.com/poolmmjp/ej_translation_api?_render=json&text=";

var httpObj = createXMLHttp();
if (httpObj) {
	var query = WScript.StdIn.ReadAll();
	httpObj.open("GET", URL + encodeURIComponent(query), false);
	httpObj.send(null);
	if (httpObj.status == 200) {
		var json = eval("(" + httpObj.responseText + ")");
		WScript.StdOut.Write(json.value.items[0].description);
	} else {
		WScript.StdOut.Write("�ʐM�G���[");
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
