/////////////////////////////////////////////////////////////////////////
//	goo.gl�ɂ��URL�Z�k�X�N���v�g
//		2010/12/27�@�������[
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
			WScript.StdOut.Write("�ϊ��ł��܂���H");
		}
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
