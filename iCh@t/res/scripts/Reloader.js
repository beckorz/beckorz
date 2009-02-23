/**
 * ログリロードクラス
 */
Reloader = Class.create();
Reloader.prototype = {
	/** コンストラクタ */
	initialize: function () {
		this.xsl = null;
		if (document.all) {
			// for IE
			this.xsl = new ActiveXObject('microsoft.XMLDOM');
		} else {
			// for Fx
			this.xsl = document.implementation.createDocument('', '', null);
		}
		this.xsl.async = false;
		this.xmlPath = '';
		this.xslPath = '';
		this.formId = '';
		this.statusId = '';
		this.logId = '';
	}

	/** Ajaxログ取得成功時処理 */
	, onSuccess: function (obj) {
		$(this.statusId).innerHTML = '';
		this.xsl.load(this.xslPath);
		if (document.all) {
			// for IE
			$(this.logId).innerHTML = obj.responseXML.transformNode(this.xsl);
		} else {
			// for Fx
			var xsltp = new XSLTProcessor();
			xsltp.importStylesheet(this.xsl);
			var content = xsltp.transformToFragment(obj.responseXML, window.document);
			$(this.logId).innerHTML = '';
			$(this.logId).appendChild(content);
		}
	}

	/** Ajaxログ取得失敗時処理 */
	, onFailure: function (obj) {
		$(this.statusId).innerHTML = '読込失敗(´･ω･｀)';
	}

	/** Ajaxログ取得処理 */
	, reload: function () {
		$(this.statusId).innerHTML = 'ロード中...';
		new Ajax.Request(this.xmlPath, {
			  onSuccess: this.onSuccess.bind(this)
			, onFailure: this.onFailure.bind(this)
			, method: 'get'
		});
	}

	/** 発言＆Ajaxログ取得処理 */
	, submit: function () {
		$(this.statusId).innerHTML = '送信中...';
		new Ajax.Request(this.xmlPath, {
			  parameters: Form.serialize(this.formId)
			, onSuccess: this.onSuccess.bind(this)
			, onFailure: this.onFailure.bind(this)
		});
	}
}
