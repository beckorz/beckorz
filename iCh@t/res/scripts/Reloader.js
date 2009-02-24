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
		this.manager = null;
	}

	/** Ajaxログ取得成功時処理 */
	, onSuccess: function (obj) {
		$(this.statusId).innerHTML = '';
		var trip = '@';
		if (this.manager) {
			var trip = this.manager.get('trip');
			if (trip == null) trip = '@';
		}
		this.xsl.load(this.xslPath);
		if (document.all) {
			// for IE
			var paramNode = this.xsl.getElementsByTagName('xsl:param');
			paramNode[0].text = trip;
			$(this.logId).innerHTML = obj.responseXML.transformNode(this.xsl);
		} else {
			// for Fx
			var xsltp = new XSLTProcessor();
			xsltp.importStylesheet(this.xsl);
			xsltp.setParameter(null, 'trip', trip);
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
