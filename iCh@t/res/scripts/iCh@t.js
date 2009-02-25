// for IE
/*@cc_on
var doc = document;
eval('var document = doc');
@*/

// リロード間隔定義(msec)
var reloadInterval = 5000;
var timerId = null;
// 切替スキンハッシュ定義
var defaultSkinKey = 'default';
var skinHash = {
	  'default': {
		  'title': 'デフォルト'
		, 'xsl': 'res/skins/default.xsl'
		, 'css': 'res/skins/default.css'
	}
	, 'midnight': {
		  'title': '深夜'
		, 'xsl': 'res/skins/midnight.xsl'
		, 'css': 'res/skins/midnight.css'
	}
	, 'balloon': {
		  'title': '吹き出し'
		, 'xsl': 'res/skins/balloon.xsl'
		, 'css': 'res/skins/balloon.css'
	}
};

// ログリロードオブジェクト初期化
var manager = new CookieManager();
var reloader = new Reloader();
reloader.xmlPath = 'iCh@t.php';
var skinKey = manager.get('skinKey');
if (skinKey == null) skinKey = defaultSkinKey;
var skin = skinHash[skinKey];
if (skin == null) {
	skinKey = defaultSkinKey;
	skin = skinHash[skinKey];
}
reloader.xslPath = skin.xsl;
reloader.formId = 'mainForm';
reloader.statusId = 'status';
reloader.logId = 'log';
reloader.manager = manager;

/** スキン切替コンボボックス初期化 */
function initSkinList() {
	var cboSkinList = document.getElementById('skinList');
	var i = 0;
	for (var key in skinHash) {
		cboSkinList.options[i++] = new Option(skinHash[key].title, key);
	}
	cboSkinList.value = skinKey;
	changeSkin(skinKey);
}

/** スキン切替コンボボックスonchange */
function onChangeSkinList(cboSkinList, index) {
	changeSkin(cboSkinList.options[index].value);
}

/** スキン切替 */
function changeSkin(key) {
	if (timerId != null) clearInterval(timerId);
	manager.set('skinKey', key, 365);
	skinKey = key;
	skin = skinHash[key];
	var cssElement = document.getElementById('css');
	var newNode = cssElement.cloneNode(true);
	newNode.href = skin.css;
	cssElement.parentNode.replaceChild(newNode, cssElement);
	reloader.xslPath = skin.xsl;
	reloader.reload();
	timerId = setInterval('reloader.reload()', reloadInterval);
}
