/////////////////////////////////////////////////////////////////////////
//	goo.glによるURL短縮スクリプト
//		2010/12/27　うっちー
/////////////////////////////////////////////////////////////////////////
var URL = "http://goo.gl/action/shorten";

var httpObj = createXMLHttp();
if (httpObj) {
	var query = WScript.StdIn.ReadLine();
	httpObj.open("POST", URL, false);
	httpObj.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	httpObj.send("url=" + encodeURIComponent(query));
	if (httpObj.status == 200) {
		var res = httpObj.responseText;
		if (/id="result" value="([^"]+)" readonly/.test(res)) {
			WScript.StdOut.Write(RegExp.$1);
		} else {
			WScript.StdOut.Write("変換できません？");
		}
	} else {
		WScript.StdOut.Write("通信エラー");
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
